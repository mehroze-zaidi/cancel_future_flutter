import 'package:async/async.dart';
import 'package:flutter/material.dart';

class DummyPostPage extends StatelessWidget {
  DummyPostPage({Key? key}) : super(key: key);
  late BuildContext context;

  late CancelableOperation getPostCancelableFuture;

  Future getUserPosts() async {
    await Future.delayed(const Duration(seconds: 5));
    return Future.value("Future Completed");
  }

  getUserLocation({required BuildContext context}) {
    // Some code that gets location
    // }


    // example 01
    void getPost() async {
      getPostCancelableFuture = CancelableOperation.fromFuture(
        getUserPosts(),
        onCancel: () => debugPrint("getPostCancelableFutureCancelled"),
      );

      final posts = await getPostCancelableFuture.value;

      // Now If I close the dialog before getting the response from api,
      // after closing I have to cancel the future .
      // it can cause memory leak as well
      getUserLocation(context: context);
    }
  }


  void cancelGetPostsCancelableOperation() {
    if (!getPostCancelableFuture.isCompleted) {
      getPostCancelableFuture.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  // your dialog here with any api call or any with any future
                  return const AlertDialog();
                },
              ).then((value) {
                //call cancel future method here
                cancelGetPostsCancelableOperation();
              });
            },
            child: const Text("Show Dialog")),
      ),
    );
  }


}
