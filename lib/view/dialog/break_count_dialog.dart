import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_todo_app/db/db.dart';
import 'package:no_todo_app/utils/screen_data.dart';
import 'package:no_todo_app/view/common/loading_view.dart';
import 'package:no_todo_app/view_model/break_count_model.dart';

class BreakCountDialog extends StatelessWidget {
  const BreakCountDialog({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer(
        builder: (context, ref, child) {
          final _model = ref.watch(breakCountModelProvider(task));
          final _loadingState = ref.watch(loadingStateProvider);

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 150.h, bottom: 20.h),
                  child: Material(
                    color: Colors.black.withOpacity(0),
                    child: Container(
                      width: ScreenData.isMobile ? 350.w : 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 32.h),
                              _buildTitle(context, _model),
                              const Expanded(child: SizedBox()),
                              _buildCounter(context, _model),
                              const Expanded(child: SizedBox()),
                              _buildButtons(context, ref, task),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _loadingState,
                child: const LoadingView(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context, BreakCountModel model) {
    return FittedBox(
      child: Text(
        model.task.title,
        style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
      ),
    );
  }

  Widget _buildCounter(BuildContext context, BreakCountModel model) {
    return Column(
      children: [
        Text(
          '破った回数',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          model.task.breakCount.toString(),
          style: TextStyle(
            color: model.countColor,
            fontWeight: FontWeight.bold,
            fontSize: ScreenData.isMobile ? 50.sp : 40.sp,
          ),
        ),
        SizedBox(height: 24.h),
        BubbleSpecialThree(
          text: model.msg,
          color: model.countColor.withOpacity(0.7),
          tail: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenData.isMobile ? 14.sp : 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, WidgetRef ref, Task task) {
    final _model = ref.watch(breakCountModelProvider(task));
    final _loadingController = ref.watch(loadingStateProvider.notifier);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: ScreenData.isMobile ? 50.h : 40.h,
              width: ScreenData.isMobile ? 150.w : 100.w,
              child: ElevatedButton(
                onPressed: () async {
                  _loadingController.startLoading();

                  await _model.decrementBreakCount();

                  _loadingController.endLoading();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Colors.blueAccent,
                ),
                child: Text('-1', style: TextStyle(fontSize: 20.sp)),
              ),
            ),
            SizedBox(
              height: ScreenData.isMobile ? 50.h : 40.h,
              width: ScreenData.isMobile ? 150.w : 100.w,
              child: ElevatedButton(
                onPressed: () async {
                  _loadingController.startLoading();

                  await _model.incrementBreakCount();

                  _loadingController.endLoading();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Colors.redAccent,
                ),
                child: Text('+1', style: TextStyle(fontSize: 20.sp)),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              '戻る',
              style: TextStyle(
                fontSize: ScreenData.isMobile ? 20.sp : 12.sp,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
