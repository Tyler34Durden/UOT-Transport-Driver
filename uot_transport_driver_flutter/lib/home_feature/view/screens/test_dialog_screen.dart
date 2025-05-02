
//  فيها كود شاشة اختبار الديالوق
//المربوط ب ديالوق الويدجت العام تحت اسم  
//? trips_dialog_widget 
//!  وصلت المحطة
//!  غادرت المحطة
//!  تأخرت الرحلة

import 'package:flutter/material.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport_driver_flutter/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport_driver_flutter/core/app_colors.dart';
import 'package:uot_transport_driver_flutter/home_feature/view/widgets/trips_dialog_widget.dart';

class TestDialogScreen extends StatefulWidget {
  const TestDialogScreen({super.key});

  @override
  State<TestDialogScreen> createState() => _TestDialogScreenState();
}

class _TestDialogScreenState extends State<TestDialogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Dialog'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true, // أو true حسب حاجتك
                builder: (BuildContext context) {
                  return const TripsDialog(
                    title: AppText(
                      lbl: 'هل وصلت محطة: الفرناج؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    content: AppText(
                      lbl:
                          'سوف تقوم بتحديث حالة الرحلة , الوصول لمحطة: الفرناج.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                    actions: [
                      AppButton(
                        onPressed: null,
                        lbl: 'وصلت',
                        height: 50,
                        width: 400,
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        onPressed: null,
                        lbl: 'إلغاء',
                        height: 50,
                        width: 400,
                        color: AppColors.secondaryColor,
                        textColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                },
              );
            },
            lbl: 'وصلت المحطة',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true, // أو true حسب حاجتك
                builder: (BuildContext context) {
                  return const TripsDialog(
                    title: AppText(
                      lbl: 'هل تريد اكمال الرحلة ؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    content: AppText(
                      lbl:
                          'سوف تقوم بمغادرة المحطة  والإنطلاق للمحطة القادمة: الفرناج.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                    actions: [
                      AppButton(
                        onPressed: null,
                        lbl: 'إنطلق',
                        height: 50,
                        width: 400,
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        onPressed: null,
                        lbl: 'إلغاء',
                        height: 50,
                        width: 400,
                        color: AppColors.secondaryColor,
                        textColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                },
              );
            },
            lbl: ' تأخرت الرحلة',
            color: AppColors.btnColor,
          ),
          AppButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true, // أو true حسب حاجتك
                builder: (BuildContext context) {
                  return const TripsDialog(
                    title: AppText(
                      lbl: 'هل تأخرت ؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    content: AppText(
                      lbl:
                          'سوف تقوم بإضافة وقت لزمن الوصول للمحطة القادمة : الفرناج',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                      ),
                    ),
                    // مثال لتعديل قائمة actions في الديالوق
                    actions: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AppButton(
                              icon: Icons.add,
                              onPressed: null,
                              height: 60,
                              width: 80,
                              textColor: AppColors.backgroundColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          AppText(
                           lbl: '00:دقيقة',
                            style: TextStyle(fontSize: 24 ,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis, 
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: AppButton(
                              icon: Icons.remove,
                              onPressed: null,
                              height: 60,
                              width: 80,
                              color: AppColors.secondaryColor,
                              textColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        onPressed: null,
                        lbl: 'تأكيد',
                        height: 50,
                        width: 400,
                        
                      ),
                      SizedBox(height: 10),
                      AppButton(
                        onPressed: null,
                        lbl: 'إلغاء',
                        height: 50,
                        width: 400,
                        color: AppColors.secondaryColor,
                        textColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                },
              );
            },
            lbl: ' غادرت المحطة',
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
