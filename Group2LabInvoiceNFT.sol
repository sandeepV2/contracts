// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@5.0.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract InvoiceMgt is ERC721, ERC721Burnable, Ownable {

    address public supplier;
    address public wholesaler;
    address public retailer;

    enum invoiceStates {Draft, Issued, Cancelled,  Paid}
    event InvoiceCreation(address from, uint256 tokenId);
    // Define struct for invoices
    struct Invoice {
        uint256 invoiceNumber;
        // these values might change from supplier to wholesaler
        // from wholeslaer to retailer.
        address seller;
        address buyer;
        uint256 amount;
        // bool approvedByWholesaler;
        bool paid;
        invoiceStates invoiceState;
        // Name of the goods.
        string goods;
        uint256 quantity;
        uint256 price;
    }

    // Mapping to store invoices by their token invoice number
    mapping(uint256 => Invoice) public invoices;

    // Modifier to restrict access to only the supplier
    modifier onlySupplier() {
        require(msg.sender == supplier, "Only the supplier can call this function.");
        _;
    }

    // Modifier to restrict access to only the wholesaler
    modifier onlyWholesaler() {
        require(msg.sender == wholesaler, "Only the wholesaler can call this function.");
        _;
    }
    
    constructor(address initialOwner)
        ERC721("MyToken", "INV")
        Ownable(initialOwner)
    {}

     // Constructor to set the roles of supplier, wholesaler, and retailer
    function setVendors(address _wholesaler, address _retailer) public {
        supplier = msg.sender;
        wholesaler = _wholesaler;
        retailer = _retailer;
    }

    // Order is created from the supplier or wholeseler 
    function createOrder(string memory goods, uint256 _quantity, uint256 _price, address _buyer, uint tokenId) onlySupplier public {
        uint256 _amount = _quantity * _price;
        require(_amount > 0, "Invalid invoice amount.");
        invoices[tokenId].invoiceNumber = tokenId;
        invoices[tokenId].seller = msg.sender;
        invoices[tokenId].buyer = _buyer;
        invoices[tokenId].amount =  _amount;
        invoices[tokenId].invoiceState = invoiceStates.Draft;
        invoices[tokenId].paid =  false;
        invoices[tokenId].goods = goods;
        invoices[tokenId].quantity = _quantity;
        invoices[tokenId].price = _price;

        safeMint(msg.sender, tokenId);
        emit InvoiceCreation(_buyer, tokenId);
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

     // cancels order can from wholesaler or retailer.
    function cancelOrder(uint256 tokenId) public {
        // you can cancel only if the order is in draft state.
        require (invoices[tokenId].invoiceState != invoiceStates.Paid);
        invoices[tokenId].invoiceState= invoiceStates.Cancelled;
        _burn(tokenId);
    }

     
    function createInvoice(address buyer, address seller, uint256 tokenId) public {
        // _approve(seller, tokenId);

        invoices[tokenId].seller = seller;
        invoices[tokenId].invoiceState = invoiceStates.Issued;

        emit InvoiceCreation(seller, tokenId);
        safeTransferFrom(seller, buyer, tokenId);
    }


    // function transferInvoice(){

    // }

    //  // Function for the supplier to generate invoices
    // // This function will create a new invoice with a unique invoice number
    // function generateInvoice(uint256 _invoiceNumber, uint256 _units, uint256 price) external onlySupplier {
    //     // goods as NFT the amount must be product of price of NFT and quantity(no of units).
    //     uint256 _amount = _units * price ;
    //     require(_invoiceNumber > 0, "Invalid invoice number.");
    //     require(_amount > 0, "Invalid invoice amount.");

    //     invoices[_invoiceNumber] = Invoice(_invoiceNumber, supplier, wholesaler, _amount, false, false);
    // }

   
}
