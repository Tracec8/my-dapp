//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract ProductPurchase{
    //定义产品结构体
    struct Product {
        uint256 id; // 产品ID
        string name; // 产品名称
        uint256 price; // 产品价格
        uint256 quantity; // 产品数量
        address seller; // 产品卖家
    }

    //存储所有的产品信息
    mapping(uint256 => Product) public products;
    uint256 public nextProductId;

    //存储用户的购买记录
    mapping(address => mapping(uint256 => uint256)) public purchaseHistory;

    //购买产品事件
    event ProductPurchased(address indexed buyer, uint256 indexed _productId, uint256 quantity);

    //添加新产品
    function addProduct(string memory _name, uint256 _price, uint256 _quantity) external  {
        require(_price > 0, "Price msut be greater than 0");
        require(_quantity > 0, "Quantity must be greater than 0");

        products[nextProductId] = Product(nextProductId, _name, _price, _quantity, msg.sender);
        nextProductId++;
    }

    //更新产品信息
    function updateProduct(uint256 _productId, string memory _name, uint256 _price, uint256 _quantity) external {
        require(_price > 0, "Price must be greater than 0");
        require(_quantity > 0, "Quantity must be greater than 0");
        require(products[_productId].seller == msg.sender, "Unauthorized");

        Product storage product = products[_productId];
        product.name = _name;
        product.price = _price;
        product.quantity = _quantity;
    }

     // 购买产品
    function buyProduct(uint256 _productId, uint256 _quantity) external payable {
        Product storage product = products[_productId];

        require(product.id != 0, "Product not found");
        require(_quantity > 0 && _quantity <= product.quantity, "Invalid quantity");
        require(msg.value >= product.price * _quantity, "Insufficient funds");

        // 扣除购买数量
        product.quantity -= _quantity;

        // 记录购买记录
        purchaseHistory[msg.sender][_productId] += _quantity;

        // 转账给卖家
        payable(product.seller).transfer(product.price * _quantity);

        // 触发购买事件
        emit ProductPurchased(msg.sender, _productId, _quantity);
    }
}
