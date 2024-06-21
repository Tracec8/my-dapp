<template>
  <div>
    <h2>Derivative Contract Details</h2>
    <div v-if="successMessage">{{ successMessage }}</div>
    <div v-if="errorMessage">{{ errorMessage }}</div>
    <div v-else>
      <div>
        <label for="derivativeId">Derivative ID:</label>
        <input type="number" id="derivativeId" v-model="derivativeId">
        <button @click="checkIsClosed">Check if Closed</button>
        <p v-if="isClosed !== null">Is Closed: {{ isClosed ? 'Yes' : 'No' }}</p>
      </div>
      <div>
        <label for="expirationId">Derivative ID:</label>
        <input type="number" id="expirationId" v-model="expirationId">
        <button @click="getExpiration">Get Expiration Time</button>
        <p v-if="expirationTime !== null">Expiration Time: {{ expirationTime }}</p>
      </div>
      <div>
        <label for="expiredId">Derivative ID:</label>
        <input type="number" id="expiredId" v-model="expiredId">
        <button @click="checkExpired">Check if Expired</button>
        <p v-if="isExpired !== null">Is Expired: {{ isExpired ? 'Yes' : 'No' }}</p>
      </div>
      <div>
        <label for="priceId">Derivative ID:</label>
        <input type="number" id="priceId" v-model="priceId">
        <button @click="getPrice">Get Derivative Price</button>
        <p v-if="derivativePrice !== null">Derivative Price: {{ derivativePrice }}</p>
      </div>
      <div>
        <label for="infoId">Derivative ID:</label>
        <input type="number" id="infoId" v-model="infoId">
        <button @click="getDerivativeInfo">Get Derivative Info</button>
        <div v-if="derivativeInfo !== null">
          <p>Seller: {{ derivativeInfo.seller }}</p>
          <p>Buyer: {{ derivativeInfo.buyer }}</p>
          <p>Price: {{ derivativeInfo.price }}</p>
          <p>Expiration: {{ derivativeInfo.expiration }}</p>
          <p>Is Closed: {{ derivativeInfo.isClosed ? 'Yes' : 'No' }}</p>
        </div>
      </div>
      <div>
        <button @click="getTotalDerivatives">Get Total Derivatives</button>
        <p v-if="totalDerivatives !== null">Total Derivatives: {{ totalDerivatives }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { isDerivativeClosed, getDerivativeExpiration, isDerivativeExpired, getDerivativeInfo, getTotalDerivatives, getDerivativePrice } from '../deploy/contract.js';

export default {
  name: 'Account',
  setup() {
    const derivativeId = ref(null);
    const isClosed = ref(null);
    const expirationId = ref(null);
    const expirationTime = ref(null);
    const expiredId = ref(null);
    const isExpired = ref(null);
    const infoId = ref(null);
    const derivativeInfo = ref(null);
    const totalDerivatives = ref(null);
    const priceId = ref(null);
    const derivativePrice = ref(null);
    const successMessage = ref('');
    const errorMessage = ref('');

    const checkIsClosed = async () => {
      try {
        isClosed.value = await isDerivativeClosed(derivativeId.value);
        successMessage.value = 'Successfully checked if closed';
      } catch (error) {
        errorMessage.value = 'Error checking if closed: ' + error.message;
      }
    };

    const getExpiration = async () => {
      try {
        expirationTime.value = await getDerivativeExpiration(expirationId.value);
        successMessage.value = 'Successfully retrieved expiration time';
      } catch (error) {
        errorMessage.value = 'Error getting expiration time: ' + error.message;
      }
    };

    const checkExpired = async () => {
      try {
        isExpired.value = await isDerivativeExpired(expiredId.value);
        successMessage.value = 'Successfully checked if expired';
      } catch (error) {
        errorMessage.value = 'Error checking if expired: ' + error.message;
      }
    };

    const getDerivativeInfo = async () => {
      try {
        derivativeInfo.value = await getDerivativeInfo(infoId.value);
        successMessage.value = 'Successfully retrieved derivative info';
      } catch (error) {
        errorMessage.value = 'Error getting derivative info: ' + error.message;
      }
    };

    const getTotalDerivatives = async () => {
      try {
        totalDerivatives.value = await getTotalDerivatives();
        successMessage.value = 'Successfully retrieved total derivatives';
      } catch (error) {
        errorMessage.value = 'Error getting total derivatives: ' + error.message;
      }
    };

    const getPrice = async () => {
      try {
        derivativePrice.value = await getDerivativePrice(priceId.value);
        successMessage.value = 'Successfully retrieved derivative price';
      } catch (error) {
        errorMessage.value = 'Error getting derivative price: ' + error.message;
      }
    };

    return {
      derivativeId,
      isClosed,
      expirationId,
      expirationTime,
      expiredId,
      isExpired,
      infoId,
      derivativeInfo,
      totalDerivatives,
      priceId,
      derivativePrice,
      successMessage,
      errorMessage,
      checkIsClosed,
      getExpiration,
      checkExpired,
      getDerivativeInfo,
      getTotalDerivatives,
      getPrice,
    };
  },
};
</script>

<style>
.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f8f8f8;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

h2 {
  margin-bottom: 30px;
  font-size: 28px;
  color: #333;
  text-align: center;
}

.form-group {
  margin-bottom: 30px;
}

.label {
  display: block;
  margin-bottom: 10px;
  font-weight: bold;
  color: #555;
}

.input-field {
  width: 100%;
  padding: 12px;
  border: 2px solid #ccc;
  border-radius: 6px;
  outline: none;
  transition: border-color 0.3s ease;
}

.input-field:focus {
  border-color: #007bff;
}

.button {
  padding: 12px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.button:hover {
  background-color: #0056b3;
}

.loading {
  margin-top: 20px;
  font-style: italic;
  color: #999;
}

.result {
  margin-top: 20px;
  font-weight: bold;
  padding: 10px;
  border-radius: 6px;
}

.result p {
  margin-bottom: 5px;
}

.result.success {
  color: #28a745;
  background-color: #d4edda;
  border-color: #c3e6cb;
}

.result.error {
  color: #dc3545;
  background-color: #f8d7da;
  border-color: #f5c6cb;
}

.result.warning {
  color: #ffc107;
  background-color: #fff3cd;
  border-color: #ffeeba;
}

.result.info {
  color: #17a2b8;
  background-color: #d1ecf1;
  border-color: #bee5eb;
}

/* Additional Styles */

.section-title {
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
}

.input-group {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.input-group label {
  margin-right: 15px;
  font-weight: bold;
  color: #555;
}

.input-group .button {
  margin-left: auto;
}

.result-message {
  margin-top: 20px;
}

.result-message p {
  margin-bottom: 10px;
}

.derivative-info {
  background-color: #f0f0f0;
  padding: 20px;
  border-radius: 8px;
  margin-top: 30px;
}

.derivative-info p {
  margin-bottom: 15px;
  font-weight: normal;
  color: #333;
}

.derivative-info p:last-child {
  margin-bottom: 0;
}
</style>
