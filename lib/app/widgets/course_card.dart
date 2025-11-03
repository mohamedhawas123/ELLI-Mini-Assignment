import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final Color statusColor;
  final VoidCallback? onTap;

  const CourseCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.statusText,
    this.statusColor = const Color(0XFFFFECD5),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(13.r),
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
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
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 5.h),
                Text(subtitle, style: TextStyle(fontSize: 9.sp)),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                  ),
                  child: Text(statusText),
                ),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 13.r,
                  color: const Color(0XFF9DA2AE),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
