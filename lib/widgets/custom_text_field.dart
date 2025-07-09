import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
 final TextEditingController controller;
 const CustomTextField({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search by city name",
          hintStyle: TextStyle(fontSize: 15.sp,color: Colors.black),
          prefixIcon: Icon(Icons.search,size: 20.sp,),
          fillColor: Colors.black.withOpacity(.19),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: Colors.black)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.purple)
          )
        )
      ),
    );
  }
}
