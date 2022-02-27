import * as React from 'react';

import { StyleSheet, View, Pressable, Text } from 'react-native';
import {} from 'react-native-datatrans-ag';
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
        console.log(result);
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
