import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({required this.imageAssetPath,required this.title,required this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = [];
  SliderModel sliderModel = SliderModel(imageAssetPath: '', title: '', desc: '');

  //1
  sliderModel.setDesc("search_info".tr);
  sliderModel.setTitle("search".tr);
  sliderModel.setImageAssetPath("assets/images/onboard1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel(imageAssetPath: '', title: '', desc: '');

  //2
  sliderModel.setDesc("cart_info".tr);
  sliderModel.setTitle("home_cart".tr);
  sliderModel.setImageAssetPath("assets/images/onboard1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel(imageAssetPath: '', title: '', desc: '');

  //3
  sliderModel.setDesc("browse_info".tr);
  sliderModel.setTitle("browse".tr);
  sliderModel.setImageAssetPath("assets/images/onboard1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel(imageAssetPath: '', title: '', desc: '');

  return slides;
}