import * as React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { startTransaction } from 'react-native-datatrans-ag';
import { initializePayment } from './api';

export default function App() {
  const handlePayButton = () => {
    initializePayment({
      amount: 7.34,
      quantity: 1,
      userId: 41,
      clubId: 3,
      productId: 6,
      mobileSDK: true,
    })
      .then((result) => {
        startTransaction(result.transactionDetails.mobileToken, {
          isTesting: true,
        })
          .then((r) => console.log(r))
          .catch((err) => {
            console.error(err);
          });
      })
      .catch((err) => {
        console.error(err);
      });
  };

  return (
    <View style={styles.container}>
      <Pressable style={styles.payButton} onPress={handlePayButton}>
        <Text style={styles.payButtonText}>Pay</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  payButton: {
    backgroundColor: '#000',
    paddingVertical: 12,
    paddingHorizontal: 36,
    borderRadius: 24,
  },
  payButtonText: {
    color: '#fff',
    fontSize: 22,
    fontWeight: '600',
  },
});
