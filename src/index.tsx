import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-datatrans-ag' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const DatatransAg = NativeModules.DatatransAg
  ? NativeModules.DatatransAg
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

// Full support for other methods have not yet implemented.
export enum PaymentType {
  VISA = 'VISA',
  MASTER_CARD = 'MASTER_CARD',
  AMERICAN_EXPRESS = 'AMERICAN_EXPRESS',
  TWINT = 'TWINT',
}

export interface PaymentMethod {
  type: PaymentType;
  alias: string | null;
}

export interface TransactionOptions {
  paymentMethods?: PaymentMethod[];
  isTesting?: boolean;
  suppressCriticalErrorDialog?: boolean;
  appCallbackScheme?: string | null;
  useCertificatePinning?: boolean;
}

export enum TransactionState {
  SUCCESS = 'SUCESS',
  CANCELED = 'CANCELED',
}

export interface TransactionResult {
  transactionId: string;
  state: TransactionState;
}

export const startTransaction = (
  mobileToken: string,
  options?: TransactionOptions
): Promise<any> => {
  if (options) {
    options.isTesting = options.isTesting ? options.isTesting : true;
    options.suppressCriticalErrorDialog = options.suppressCriticalErrorDialog
      ? options.suppressCriticalErrorDialog
      : false;
    options.appCallbackScheme = options.appCallbackScheme
      ? options.appCallbackScheme
      : null;
    options.useCertificatePinning = options.useCertificatePinning
      ? options.useCertificatePinning
      : true;
    return DatatransAg.startTransaction(mobileToken, options);
  } else {
    return DatatransAg.startTransaction(mobileToken, {});
  }
};
