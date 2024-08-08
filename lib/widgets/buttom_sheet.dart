import 'package:flutter/material.dart';

Future<dynamic> LayerSetButtomSheet(BuildContext context){
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context)
  {
    return Container(
        height: 200,
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Modal BottomSheet'),
              ElevatedButton(
                child: const Text('Close BottomSheet'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        )
    );
  }
  );
}

Future<dynamic> ToolsButtomSheet(BuildContext context){
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context)
      {
        return Container(
            height: 200,
            color: Colors.amber,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Modal BottomSheet'),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
        );
      }
  );
}
