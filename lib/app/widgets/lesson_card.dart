import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  const LessonCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.r),
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C75D2) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: isSelected ? Color(0XFFDBE9FE) : Colors.black87,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF5292DC)
                      : Colors.transparent,
                ),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 12.r,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
