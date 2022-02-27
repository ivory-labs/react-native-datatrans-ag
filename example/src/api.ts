import axios from 'axios';

const DOMAIN = 'mysponsor-service.herokuapp.com';

export interface InitializePaymentParams {
  userId: number;
  clubId: number;
  productId: number;
  amount: number;
  quantity: number;
  mobileSDK: boolean;
}

export interface TransactionDetails {
  mobileToken: string;
}

export interface InitializePaymentResult {
  id: string;
  cubeId: number;
  userId: number;
  productId: number;
  amount: number;
  transactionDetails: TransactionDetails;
}

export const initializePayment = async (
  params: InitializePaymentParams
): Promise<InitializePaymentResult> => {
  const { data } = await axios.post(
    `https://${DOMAIN}/api/v1/payments/initialize-twint`,
    params
  );
  return data;
};
