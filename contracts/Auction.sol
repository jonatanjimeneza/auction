// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @title Auction
 * @dev Contrato de subastas descentralizadas
 */
contract Auction {
    // Variables de estado
    address public auctioneer;
    uint public highestBid;
    address public highestBidder;

    /**
     * @dev Evento emitido cuando se realiza una nueva puja
     */
    event BidPlaced(address bidder, uint amount);

    /**
     * @dev Modificador para permitir solo al subastador ejecutar una función
     */
    modifier onlyAuctioneer() {
        require(msg.sender == auctioneer, "Only auctioneer can call this function.");
        _;
    }

    /**
     * @dev Constructor del contrato
     */
    constructor() {
        auctioneer = msg.sender;
    }

/**
 * @dev Función para realizar una puja en la subasta.
 * Requiere que la puja sea mayor que la puja más alta actual.
 * Si se realiza una nueva puja, los fondos del pujador anterior se devuelven.
 * Emite un evento BidPlaced con la dirección del pujador y la cantidad de la puja.
 */
    function placeBid() public payable {
        require(msg.value > highestBid, "Bid must be higher than the current highest bid.");

        if (highestBid > 0) {
            // Devolver fondos al pujador anterior
            payable(highestBidder).transfer(highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, msg.value);
    }

    /**
     * @dev Función para finalizar la subasta y transferir los fondos al subastador
     */
    function finalizeAuction() public onlyAuctioneer {
        require(highestBid > 0, "No bids have been placed.");

        // Transferir fondos al subastador
        payable(auctioneer).transfer(highestBid);

        // Reiniciar la subasta
        highestBid = 0;
        highestBidder = address(0);
    }
}
