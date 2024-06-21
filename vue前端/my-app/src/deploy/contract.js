// 导入 web3 和 contractABI
import Web3 from 'web3';
import ContractABI from '../contracts/DerivativeContract.json';
import Contract1ABI from '../contracts/ProductPurchase.json';

// 使用 window.ethereum 初始化 web3 实例
const web3 = new Web3(window.ethereum);

//替换为你的智能合约地址
const contractAddress = '0x5b067949b3Ef83c3ab1406c367BF6EA6f7bf68a8';
const contratc1Address = '0x345C2d21958d7B562736e797fD00E9E7008a17b4';

//创建contract实例
const contract = new web3.eth.Contract(ContractABI, contractAddress);
const contract1 = new web3.eth.Contract(Contract1ABI, contratc1Address);

//充值数字资产
export async function deposit(amount) {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.deposit().send({
        from : address,
        value: web3.utils.toWei(amount, 'ether'),
    });
}
//创建新的金融衍生品合约
export async function createDerivative(buyer, price, expiration) {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.createDerivative(buyer, price, expiration).send({
        from: address,
    });
}
//关闭指定ID的金融衍生品合约
export async function closeDerivative(derivativeId) {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.closeDerivative(derivativeId).send({
        from: address,
    });
}
//修改金融衍生品合约的价格
export async function updateDerivativePrice(derivativeId, newPrice) {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.updateDerivativePrice(derivativeId, newPrice).send({
        from: address,
    });
}
//结算指定ID的金融衍生品合约
export async function settleDerivative(derivativeId) {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.settleDerivative(derivativeId).send({
        from: address,
    });
}
//提取合约中余额
export async function withdrawBalance() {
    const accounts = await web3.eth.getAccounts();
    const address = accounts[0];

    await contract.methods.withdrawBalance(address).send({
        from: address,
    });
} 
//判断指定ID的金融衍生品合约是否已经关闭
export async function isDerivativeClosed(derivativeId) {
    return await contract.methods.isDerivativeClosed(derivativeId).call();
}
//查询指定ID的金融衍生品到期时间
export async function getDerivativeExpiration(derivativeId) {
    return await contract.methods.getDerivativeExpiration(derivativeId).call();
}
//检查指定金融衍生品合约是否已到期
export async function isDerivativeExpired(derivativeId) {
    return await contract.methods.isDerivativeExpired(derivativeId).call();
}
//查询指定ID的金融衍生品合约信息
export async function getDerivativeInfo(derivativeId) {
    return await contract.methods.getDerivativeInfo(derivativeId).call();
}
//获取当前合约的总金融衍生品数量
export async function getTotalDerivatives() {
    return await contract.methods.getTotalDerivatives().call();
}
//获取指定ID的金融衍生品合约的价格
export async function getDerivativePrice(derivativeId) {
    return await contract.methods.getDerivativePrice(derivativeId).call();
}

//添加新产品
export const addProduct = async (name, price, quantity) => {
    const accounts = await web3.eth.getAccounts();
    await contract1.methods.addProduct(name, price, quantity).send({
        from: accounts[0],
    });
};

//更新产品信息
export const updateProduct = async (productId, name, price, quantity) => {
    const accounts = await web3.eth.getAccounts();
    await contract1.methods.updateProduct(productId, name, price, quantity).send({
        from: accounts[0],
    });
};

//购买产品
export const buyProduct = async (productId, quantity, price) => {
    const accounts = await web3.eth.getAccounts();
    await contract1.methods.buyProduct(productId, quantity).send({
        from: accounts[0],
        value: price * quantity,
    });
};