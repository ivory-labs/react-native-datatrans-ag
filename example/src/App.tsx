import * as React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';

export default function App() {
  const handlePayButton = () => {
    /**
     * Pass the nesaccary paramters and initialize the payment. 
     * This will give you a `mobileToken` which can be passed
     * to the `startTransaction` function with other supported 
     * payment options. 
     
      const result = await startTransaction(mobileToken, {
        isTesting: true,
      });

     */
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
