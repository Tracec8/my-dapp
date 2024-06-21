<template>
  <div class="market">
    <h2>交易市场</h2>
    <div v-if="isLoading" class="loading">加载中...</div>
    <div v-else>
      <div class="products">
        <div class="product" v-for="(product, index) in products" :key="index">
          <h3>{{ product.name }}</h3>
          <p>价格: {{ product.price }}</p>
          <p>交易量: {{ product.volume }}</p>
          <button @click="handleAddProduct">添加新产品</button>
          <button @click="handleUpdateProduct(product.id)">更新产品信息</button>
          <button @click="handleBuyProduct(product)">购买</button>
        </div>
      </div>
    </div>

    <!-- 添加新产品表单 -->
    <div v-if="showAddProductForm">
      <h3>添加新产品</h3>
      <form @submit.prevent="addNewProduct">
        <label for="productName">产品名称:</label>
        <input type="text" id="productName" v-model="newProductName" required>
        <label for="productPrice">产品价格:</label>
        <input type="number" id="productPrice" v-model="newProductPrice" required>
        <label for="productQuantity">产品数量:</label>
        <input type="number" id="productQuantity" v-model="newProductQuantity" required>
        <button type="submit">确认添加</button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { addProduct, updateProduct, buyProduct } from '../deploy/contract.js';

export default {
  name: 'Market',
  setup() {
    const isLoading = ref(true);
    const products = ref([]);
    const showAddProductForm = ref(false);
    const newProductName = ref('');
    const newProductPrice = ref(0);
    const newProductQuantity = ref(0);

    // 模拟加载数据
    const fetchData = async () => {
      try {
        // 模拟获取数据的异步操作
        isLoading.value = true;
        await new Promise(resolve => setTimeout(resolve, 1000)); // 模拟延迟1秒
        const data = [
          { id: 1, name: 'Product A', price: 100, volume: 500 },
          { id: 2, name: 'Product B', price: 150, volume: 300 },
          { id: 3, name: 'Product C', price: 120, volume: 400 },
          { id: 4, name: 'Product D', price: 130, volume: 500 },
          { id: 5, name: 'Product E', price: 200, volume: 100 },
          { id: 6, name: 'Product F', price: 160, volume: 200 },
        ];
        products.value = data;
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        console.error(error);
      }
    };

    // 添加新产品
    const handleAddProduct = () => {
      showAddProductForm.value = true;
    };

    const addNewProduct = async () => {
      try {
        await addProduct(newProductName.value, newProductPrice.value, newProductQuantity.value);
        fetchData();
        alert('添加新产品成功！');
        // 清空表单输入
        newProductName.value = '';
        newProductPrice.value = 0;
        newProductQuantity.value = 0;
        showAddProductForm.value = false;
      } catch (error) {
        console.error('添加新产品出错:', error);
        alert('添加新产品失败，请稍后重试。');
      }
    };

    // 更新产品信息
    const handleUpdateProduct = async (productId) => {
      const updatedName = prompt('请输入更新后的产品名称:');
      const updatedPrice = Number(prompt('请输入更新后的产品价格:'));
      const updatedQuantity = Number(prompt('请输入更新后的产品数量:'));
      if (updatedName && updatedPrice && updatedQuantity) {
        try {
          await updateProduct(productId, updatedName, updatedPrice, updatedQuantity);
          fetchData();
          alert('更新产品信息成功！');
        } catch (error) {
          console.error('更新产品信息出错:', error);
          alert('更新产品信息失败，请稍后重试。');
        }
      } else {
        alert('请输入有效的更新信息！');
      }
    };

    // 购买产品
    const handleBuyProduct = async (product) => {
      const buyQuantity = Number(prompt('请输入购买数量:'));
      if (buyQuantity && buyQuantity > 0) {
        try {
          await buyProduct(product.id, buyQuantity, product.price);
          fetchData();
          alert('购买成功！');
        } catch (error) {
          console.error('购买产品出错:', error);
          alert('购买失败，请稍后重试。');
        }
      } else {
        alert('请输入有效的购买数量！');
      }
    };

    // 组件加载时获取数据
    onMounted(() => {
      fetchData();
    });

    return {
      isLoading,
      products,
      showAddProductForm,
      newProductName,
      newProductPrice,
      newProductQuantity,
      handleAddProduct,
      addNewProduct,
      handleUpdateProduct,
      handleBuyProduct,
    };
  },
};
</script>

<style>
.market {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f8f8f8;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  margin-bottom: 20px;
  font-size: 24px;
  color: #333;
}

.loading {
  margin-top: 20px;
  font-style: italic;
  color: #999;
}

.products {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  grid-gap: 20px;
}

.product {
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 10px;
}

.product h3 {
  margin-bottom: 5px;
  font-size: 18px;
}

.product p {
  margin-bottom: 5px;
}

.product button {
  margin-top: 10px;
  padding: 8px 16px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.product button:hover {
  background-color: #0056b3;
}
</style>