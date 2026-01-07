import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

interface PushNotificationData {
  cartId: string;
  productName: string;
  userId: string;
  userName: string;
  action: 'purchased' | 'removed' | 'added';
}

/**
 * Cloud Function que envía notificaciones push cuando cambia un carrito compartido
 * Se ejecuta cuando se escribe en /carts/{cartId}
 */
export const sendCartNotification = functions.firestore
  .document('carts/{cartId}')
  .onUpdate(async (change, context) => {
    const cartId = context.params.cartId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    if (!beforeData || !afterData) return;

    const beforeItems = beforeData.items || [];
    const afterItems = afterData.items || [];

    // Detectar productos marcados como comprados
    for (const afterItem of afterItems) {
      const beforeItem = beforeItems.find((i: any) => i.productId === afterItem.productId);
      
      if (beforeItem && !beforeItem.isPurchased && afterItem.isPurchased) {
        await sendPushToCartParticipants({
          cartId,
          productName: afterItem.name,
          userId: afterItem.purchasedBy || 'unknown',
          userName: await getUserName(afterItem.purchasedBy),
          action: 'purchased',
        }, afterData.ownerId);
      }
    }

    // Detectar productos eliminados
    for (const beforeItem of beforeItems) {
      const stillExists = afterItems.find((i: any) => i.productId === beforeItem.productId);
      if (!stillExists) {
        await sendPushToCartParticipants({
          cartId,
          productName: beforeItem.name,
          userId: afterData.lastModifiedBy || 'unknown',
          userName: await getUserName(afterData.lastModifiedBy),
          action: 'removed',
        }, afterData.ownerId);
      }
    }

    // Detectar productos añadidos
    for (const afterItem of afterItems) {
      const existed = beforeItems.find((i: any) => i.productId === afterItem.productId);
      if (!existed) {
        await sendPushToCartParticipants({
          cartId,
          productName: afterItem.name,
          userId: afterData.lastModifiedBy || 'unknown',
          userName: await getUserName(afterData.lastModifiedBy),
          action: 'added',
        }, afterData.ownerId);
      }
    }
  });

/**
 * Envía notificación push a todos los participantes del carrito excepto quien hizo el cambio
 */
async function sendPushToCartParticipants(data: PushNotificationData, ownerId: string) {
  const { cartId, productName, userName, action, userId } = data;

  // Obtener datos del carrito
  const cartDoc = await admin.firestore().collection('carts').doc(cartId).get();
  const cartData = cartDoc.data();
  
  if (!cartData) {
    console.log('Carrito no encontrado');
    return;
  }

  const participantIds: string[] = [
    ownerId,
    ...(cartData.participantIds || [])
  ].filter((id: string) => id !== userId); // No enviar al que hizo el cambio

  if (participantIds.length === 0) {
    console.log('No hay participantes para notificar');
    return;
  }

  const tokens: string[] = [];

  // Obtener tokens FCM de cada participante
  for (const participantId of participantIds) {
    try {
      const userDoc = await admin.firestore().collection('users').doc(participantId).get();
      const userData = userDoc.data();
      if (userData?.fcmToken) {
        tokens.push(userData.fcmToken);
      }
    } catch (error) {
      console.error(`Error obteniendo token de usuario ${participantId}:`, error);
    }
  }

  if (tokens.length === 0) {
    console.log('No hay tokens FCM válidos para enviar notificaciones');
    return;
  }

  // Preparar mensaje según la acción
  let title = '';
  let body = '';

  switch (action) {
    case 'purchased':
      title = 'Producto comprado';
      body = `${userName} compró "${productName}"`;
      break;
    case 'removed':
      title = 'Producto eliminado';
      body = `${userName} eliminó "${productName}"`;
      break;
    case 'added':
      title = 'Producto añadido';
      body = `${userName} añadió "${productName}"`;
      break;
  }

  // Enviar notificación multicast
  const message: admin.messaging.MulticastMessage = {
    tokens,
    notification: {
      title,
      body,
    },
    data: {
      cartId,
      productName,
      action,
      userId,
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      route: '/shared-cart',
    },
    android: {
      priority: 'high',
      notification: {
        channelId: 'cart_updates',
        icon: 'ic_notification',
        color: '#4CAF50',
        sound: 'default',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log(`[OK] Notificación enviada a ${response.successCount}/${tokens.length} dispositivos`);
    
    if (response.failureCount > 0) {
      console.error(`[ERROR] ${response.failureCount} notificaciones fallaron`);
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          console.error(`Error en token ${idx}:`, resp.error);
          // Limpiar tokens inválidos
          if (resp.error?.code === 'messaging/invalid-registration-token' ||
              resp.error?.code === 'messaging/registration-token-not-registered') {
            cleanupInvalidToken(tokens[idx]);
          }
        }
      });
    }
  } catch (error) {
    console.error('Error enviando notificación:', error);
  }
}

/**
 * Obtiene el nombre de usuario desde Firestore
 */
async function getUserName(userId: string | undefined): Promise<string> {
  if (!userId) return 'Usuario desconocido';

  try {
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    const userData = userDoc.data();
    return userData?.displayName || userData?.email || 'Usuario';
  } catch (error) {
    console.error('Error obteniendo nombre de usuario:', error);
    return 'Usuario';
  }
}

/**
 * Limpia tokens FCM inválidos de Firestore
 */
async function cleanupInvalidToken(token: string) {
  try {
    const usersSnapshot = await admin.firestore()
      .collection('users')
      .where('fcmToken', '==', token)
      .get();

    const batch = admin.firestore().batch();
    usersSnapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { fcmToken: admin.firestore.FieldValue.delete() });
    });

    await batch.commit();
    console.log(`🧹 Token inválido limpiado: ${token.substring(0, 20)}...`);
  } catch (error) {
    console.error('Error limpiando token:', error);
  }
}

/**
 * HTTP Function para enviar notificaciones manuales (testing o desde app)
 */
export const sendManualNotification = functions.https.onCall(async (data, context) => {
  // Verificar autenticación
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Usuario debe estar autenticado'
    );
  }

  const { cartId, productName, action } = data;

  if (!cartId || !productName || !action) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Faltan parámetros requeridos'
    );
  }

  const userId = context.auth.uid;
  const userName = await getUserName(userId);

  // Obtener datos del carrito
  const cartDoc = await admin.firestore().collection('carts').doc(cartId).get();
  const cartData = cartDoc.data();

  if (!cartData) {
    throw new functions.https.HttpsError('not-found', 'Carrito no encontrado');
  }

  // Verificar permisos
  const isOwner = cartData.ownerId === userId;
  const isParticipant = (cartData.participantIds || []).includes(userId);

  if (!isOwner && !isParticipant) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'No tienes permisos para este carrito'
    );
  }

  await sendPushToCartParticipants({
    cartId,
    productName,
    userId,
    userName,
    action,
  }, cartData.ownerId);

  return { success: true, message: 'Notificación enviada' };
});
