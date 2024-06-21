<template>
  <div class="trade">
    <div class="trade-form">
      <h2>创建交易订单</h2>
      <form @submit.prevent="createOrder">
        <label for="buyer">买方地址：</label>
        <input type="text" id="buyer" v-model="buyer" required>
        <label for="price">价格：</label>
        <select v-model="priceUnit">
          <option value="wei">Wei</option>
          <option value="gwei">Gwei</option>
          <option value="finney">Finney</option>
          <option value="ether">Ether</option>
        </select>
        <div class="price-input">
          <input type="number" id="priceAmount" v-model="priceAmount" required>
        </div>
        <label for="expiration">到期时间：</label>
        <input type="datetime-local" id="expiration" v-model="expiration" required>
        <button type="submit">提交订单</button>
      </form>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
    </div>
    <div class="trade-actions">
      <h2>交易操作</h2>
      <form @submit.prevent="handleDeposit">
        <label for="depositAmount">充值金额：</label>
        <select v-model="depositUnit">
          <option value="wei">Wei</option>
          <option value="gwei">Gwei</option>
          <option value="finney">Finney</option>
          <option value="ether">Ether</option>
        </select>
        <input type="number" id="depositAmount" v-model="depositAmount" required>
        <button type="submit">充值数字资产</button>
      </form>
      <form @submit.prevent="handleClose">
        <label for="closeDerivativeId">关闭合约 ID:</label>
        <input type="number" id="closeDerivativeId" v-model="closeDerivativeId" required>
        <button type="submit">关闭指定金融衍生品</button>
      </form>
      <form @submit.prevent="handleUpdatePrice">
        <label for="updateDerivativeId">修改合约 ID:</label>
        <input type="number" id="updateDerivativeId" v-model="updateDerivativeId" required>
        <label for="newPrice">新价格：</label>
        <input type="number" id="newPrice" v-model="newPrice" required>
        <button type="submit">修改指定衍生品价格</button>
      </form>
      <form @submit.prevent="handleSettle">
        <label for="settleDerivativeId">结算合约 ID:</label>
        <input type="number" id="settleDerivativeId" v-model="settleDerivativeId" required>
        <button type="submit">结算指定ID的金融衍生品合约</button>
      </form>
      <form @submit.prevent="handleWithdrawBalance">
        <label for="withdrawAddress">提取地址：</label>
        <input type="text" id="withdrawAddress" v-model="withdrawAddress" required>
        <label for="withdrawBalanceAmount">提取金额：</label>
        <input type="number" id="withdrawBalanceAmount" v-model="withdrawBalanceAmount" required>
        <button type="submit">提取余额</button>
      </form>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
      <p v-if="successMessage" class="success-message">{{ successMessage }}</p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { createDerivative, deposit, closeDerivative, updateDerivativePrice, settleDerivative, withdrawBalance } from '../deploy/contract.js'; // 导入智能合约交互函数

export default {
  setup() {
    const buyer = ref('');
    const priceAmount = ref('');
    const priceUnit = ref('ether');
    const expiration = ref('');
    const withdrawAddress = ref('');
    const withdrawBalanceAmount = ref('');
    const errorMessage = ref('');
    const successMessage = ref('');
    const depositAmount = ref('');
    const depositUnit = ref('wei');
    const closeDerivativeId = ref('');
    const updateDerivativeId = ref('');
    const newPrice = ref('');
    const settleDerivativeId = ref('');


    const createOrder = async () => {
      try {
        //将到期时间转换为Unix时间戳
        const expirationTimeStamp = new Date(expiration.value).getTime() / 1000; // 将毫秒转换为秒
        //将价格转换为对应的币种
        const convertedPrice = convertedPriceToWei(priceAmount.value, priceUnit.value);

        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        await createDerivative(buyer.value, convertedPrice, expirationTimeStamp);

         // 保存合约信息到本地存储
         saveDerivative({ buyer: buyer.value, price: convertedPrice, expiration: expirationTimeStamp });

        successMessage.value = '订单创建成功';

        // 导航到 market 页面，同时传递合约信息
        router.push({ name: 'market', params: { newDerivative: { buyer: buyer.value, price: convertedPrice, expiration: expirationTimeStamp } } });
      } catch (error) {
        errorMessage.value = '订单创建失败：' + error.message;
      }
    };

     // 在本地存储中保存合约信息
     const saveDerivative = (derivative) => {
       // 从本地存储中获取已保存的合约信息数组，如果没有则创建一个空数组
       const savedDerivatives = JSON.parse(localStorage.getItem('derivatives')) || [];
       
       // 将新的合约信息添加到数组中
       savedDerivatives.push(derivative);
       
       // 将更新后的数组保存回本地存储
       localStorage.setItem('derivatives', JSON.stringify(savedDerivatives));
     };

    //转换价格到Wei
    const convertedPriceToWei = (amount, unit) => {
      switch (unit) {
        case 'ether':
          return amount;
        case 'gwei':
          return amount * 1e9; // 1 Gwei = 1e9 Wei
        case 'finney':
          return amount * 1e15; // 1 Finney = 1e15 Wei
        default:
          return amount;
      }
    }

    const handleDeposit = async () => {
      try {
        const amount = parseFloat(depositAmount.value);
        const unit = depositUnit.value;
        const convertedAmount = convertedPriceToWei(amount, unit);

        await deposit(convertedAmount);
        successMessage.value = `成功充值 ${amount} ${unit}`;
      } catch (error) {
        errorMessage.value = '充值失败：' + error.message;
      }
    };

    const handleClose = async () => {
      try {
        const derivativeId = closeDerivativeId.value;
        await closeDerivative(derivativeId);
        successMessage.value = `成功关闭合约 ID 为 ${derivativeId} 的金融衍生品`;
      } catch (error) {
        errorMessage.value = '关闭合约失败：' + error.message;
      }
    };

    const handleUpdatePrice = async () => {
      try {
        const derivativeId = updateDerivativeId.value;
        const price = newPrice.value;
        await updateDerivativePrice(derivativeId, price);
        successMessage.value = `成功修改合约 ID 为 ${derivativeId} 的价格为 ${price}`;
      } catch (error) {
        errorMessage.value = '修改价格失败：' + error.message;
      }
    };

    const handleSettle = async () => {
      try {
        const derivativeId = settleDerivativeId.value;
        await settleDerivative(derivativeId);
        successMessage.value = `成功结算合约 ID 为 ${derivativeId} 的金融衍生品合约`;
      } catch (error) {
        errorMessage.value = '结算合约失败：' + error.message;
      }
    };

    const handleWithdrawBalance = async () => {
      try {
        const address = withdrawAddress.value;
        const amount = parseFloat(withdrawBalanceAmount.value);

        // 调用提取余额的方法
        await withdrawBalance(address, amount);

        successMessage.value = `成功提取 ${amount} ETH 到地址 ${address}`;
        errorMessage.value = ''; // 清空错误消息
      } catch (error) {
        errorMessage.value = '提取余额失败：' + error.message;
        successMessage.value = ''; // 清空成功消息
      }
    };

    return {
      buyer,
      priceAmount,
      priceUnit,
      expiration,
      withdrawAddress,
      withdrawBalanceAmount,
      errorMessage,
      successMessage,
      depositAmount,
      depositUnit,
      closeDerivativeId,
      updateDerivativeId,
      newPrice,
      settleDerivativeId,
      createOrder,
      handleDeposit,
      handleClose,
      handleUpdatePrice,
      handleSettle,
      handleWithdrawBalance,
    };
  },
};
</script>

<style>
.trade {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 20px;
}

.trade-form {
  max-width: 400px;
  width: 100%;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
}

.trade-form h2 {
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.trade-form label {
  display: block;
  margin-bottom: 10px;
  font-weight: bold;
}

.trade-form input {
  width: 100%;
  padding: 8px;
  margin-bottom: 15px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.trade-form button {
  width: 100%;
  padding: 10px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.trade-form button:hover {
  background-color: #0056b3;
}

.error-message {
  color: red;
  margin-top: 10px;
}

.success-message {
  color: green;
  margin-top: 10px;
}

.trade-actions {
  margin-top: 40px;
}

.trade-actions h2 {
  margin-bottom: 20px;
  font-size: 1.3rem;
}

.trade-actions form {
  margin-bottom: 15px;
}

.trade-actions label {
  display: inline-block;
  margin-bottom: 5px;
  font-weight: bold;
}

.trade-actions input {
  width: calc(100% - 20px);
  padding: 8px;
  margin-bottom: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.trade-actions button {
  padding: 8px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.trade-actions button:hover {
  background-color: #0056b3;
}

/* 模态框样式 */
.modal {
  display: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}

.modal-content {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.modal button {
  padding: 8px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.modal button:hover {
  background-color: #0056b3;
}
</style>