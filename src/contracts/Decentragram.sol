pragma solidity ^0.5.0;

contract Decentragram {
  string public name= "Decentragram";


  // Store Image
  uint public imageCount=0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;

  }

  event ImageCreated(
    uint id, 
    string hash, 
    string description, 
    uint tipAmount, 
    address payable author);

  event ImageTip(
    uint id, 
    string hash,
    string description,
    uint tipAmount, 
    address payable author);  

  //Create Image
  function uploadImage(string memory _imgHash,string memory _description)public{
    require(bytes(_description).length > 0 );//description is not empity
    require(bytes(_imgHash).length > 0 );//image hash is not empty
    require(msg.sender != address(0x0));//only the contract owner can upload image

    //image count id

    imageCount++;

    //add image to contract
    images[imageCount]=Image(imageCount,_imgHash,_description,0,msg.sender);

    emit ImageCreated(imageCount,_imgHash,_description,0,msg.sender);
  }

  //Tip Image

  function tipImageOwner(uint _id)public payable{

    require(_id > 0 && _id<=imageCount);//image id is valid

    //fetch image
    Image memory _image =images[_id];

    //fetch the author of the image
    address payable _author = _image.author;

    //fetch the tip amount
    address(_author).transfer(msg.value);

    //imcrement the tip amount

    _image.tipAmount+=msg.value;

    //update the image
    images[_id]=_image;

    emit ImageTip(_id,_image.hash,_image.description,_image.tipAmount,_image.author);

  }



}