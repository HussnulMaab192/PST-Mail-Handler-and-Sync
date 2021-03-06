import 'package:flutter/material.dart';
import 'package:pst1/HelperClasses/folder_details.dart';
import 'package:pst1/providers/Db.dart';

import '../Screens/general_file.dart';
import '../Screens/inbox_page.dart';
import '../Screens/popup.dart';

class MyDrawerWidget extends StatefulWidget {
  List<FolderDetail> flist;

  MyDrawerWidget(accId, {Key? key, required this.flist}) : super(key: key);

  @override
  State<MyDrawerWidget> createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  late BuildContext ct;
  static List<FolderDetail> pmeu = [];
  @override
  Widget build(BuildContext context) {
    pmeu.addAll(widget.flist);
    print('List of flist ' + widget.flist.length.toString());
    print('List of pmenu ' + pmeu.length.toString());
    ct = context;
    Widget w = const Text("");
    print('length of folder = ' + widget.flist.length.toString());
    for (int i = 0; i < widget.flist.length; i++) {
      w = Row(children: [
        Expanded(
          child: ExpansionTile(
            title: Text(widget.flist[i].name),
            children: getChildHirerachy(
                widget.flist[i].childrens, context, widget.flist[i].id),
          ),
        )
      ]);
    }
    return w;
  }
}

List<Widget> getChildHirerachy(
    List<FolderDetail> children, BuildContext context, int index) {
  List<Widget> exp = [];
  List<Widget> emplist = [];
  if (children.isEmpty) return emplist;

  for (int i = 0; i < children.length; i++) {
    print('Printintig....' + children[i].name);
    exp.add(
      ExpansionTile(
        key: Key(children[i].id.toString()),
        leading: IconButton(
            onPressed: () async {
              print('before calling ids are');
              // print('from :' + widget.index!.toString());
              // print('to :' + widget.fdetail[i].id.toString());
              DBHandler db = await DBHandler.getInstnace();
              db.UpdateFolder(index, children[i].id);
              //  db.updateFolder(widget.index!, widget.fdetail[i].id);

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Folder moved "),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("ok"),
                        ),
                      ],
                    );
                  });
              //   Navigator.pop(context);
            },
            icon: const Icon(Icons.folder)),
        title: InkWell(
            onLongPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GeneralScreen(
                        id: children[i].id,
                        name: children[i].name,
                      )));
            },
            child: Text(children[i].name)),
        children: getChildHirerachy(children[i].childrens, context, index),
        trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              print('before alert..');
              print(children[i].name);
              print(Key);

              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (cnt) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (cont) {
                                    TextEditingController controller =
                                        TextEditingController();
                                    return AlertDialog(
                                      actions: [
                                        const Center(
                                            child: Text("Enter name ")),
                                        TextField(
                                          controller: controller,
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              // yaha db main first time  null ata hai !
                                              DBHandler db =
                                                  await DBHandler.getInstnace();
                                              await db.insertData(
                                                  105,
                                                  controller.text,
                                                  1,
                                                  children[i].id);

                                              Navigator.of(context).pop();

                                              showDialog(
                                                  context: context,
                                                  builder: (con) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Data is inserted..'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              FolderDetail fd =
                                                                  FolderDetail();
                                                              fd.name =
                                                                  controller
                                                                      .text;
                                                              children[i]
                                                                  .childrens
                                                                  .add(fd);

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'))
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const Text("Create"))
                                      ],
                                    );
                                  });
                            },
                            child: const Text("create")),
                        TextButton(
                            onPressed: () {
                              //Navigator.of(context).pop();
                              print(children[i].fid);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PopupDislpay.con(
                                        fdetail: InboxPage.finfo,
                                        index: children[i].id,
                                        isMail: false,
                                        selected: [],
                                      )));
                            },
                            child: const Text("Move")),
                        TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              DBHandler db = await DBHandler.getInstnace();
                              await db.deleteFolder(children[i].id);
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (cont) {
                                    return AlertDialog(
                                      title: const Text('Folder Deleted..'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("ok"))
                                      ],
                                    );
                                  });
                            },
                            child: const Text("Delete")),
                      ],
                    );
                  });
            }),
      ),
    );
  }
  print('exp:::');
  print(exp);
  List<Widget> ep = [];
  ep.addAll(exp);
  exp.clear();
  return ep;
}

// List<Widget> getChildHirerachyPopup(
//     List<FolderDetail> children, BuildContext context) {
//   List<Widget> exp = [];
//   List<Widget> emplist = [];
//   if (children.isEmpty) return emplist;

//   for (int i = 0; i < children.length; i++) {
//     print('Printintig....' + children[i].name);
//     exp.add(
//       ExpansionTile(
//         leading: const Icon(Icons.folder),
//         title: Text(children[i].name),
//         children: getChildHirerachy(children[i].childrens, context),
//         trailing: IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               print("before alert");
//               showDialog(
//                   barrierDismissible: false,
//                   context: context,
//                   builder: (cnt) {
//                     return AlertDialog(
//                       actions: [
//                         TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               showDialog(
//                                   context: context,
//                                   builder: (cont) {
//                                     TextEditingController controller =
//                                         TextEditingController();
//                                     return AlertDialog(
//                                       actions: [
//                                         const Center(
//                                             child: Text("Enter name ")),
//                                         TextField(
//                                           controller: controller,
//                                         ),
//                                         TextButton(
//                                             onPressed: () async {
//                                               // yaha db main first time  null ata hai !
//                                               DBHandler db =
//                                                   await DBHandler.getInstnace();
//                                               await db.insertData(
//                                                   //    Sdab
//                                                   // yahan agr id auto ki jaay tu error resolve ho jay ga but
//                                                   // getNextId is not working for any other folder except accounts
//                                                   105,
//                                                   controller.text,
//                                                   1,
//                                                   children[i].id);
//                                               Navigator.of(context).pop();
//                                               // dialogue box to show that data is inserted !!!
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (con) {
//                                                     return AlertDialog(
//                                                       title: const Text(
//                                                           'Data is inserted..'),
//                                                       actions: [
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               FolderDetail fd =
//                                                                   FolderDetail();
//                                                               fd.name =
//                                                                   controller
//                                                                       .text;
//                                                               children[i]
//                                                                   .childrens
//                                                                   .add(fd);

//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                             },
//                                                             child: const Text(
//                                                                 'OK'))
//                                                       ],
//                                                     );
//                                                   });
//                                             },
//                                             child: const Text("Create"))
//                                       ],
//                                     );
//                                   });
//                             },
//                             child: const Text("create")),
//                         //  Move button
//                         TextButton(
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .push(MaterialPageRoute(builder: (context) {
//                                 // i ki value sai nai aa rai !!!!!!!!
//                                 print('VAlue of i = ' + i.toString());
//                                 return PopupDislpay.con(
//                                     fdetail: InboxPage.finfo, index: i);
//                               }));
//                             },
//                             child: const Text("Move")),
//                         // delete button
//                         TextButton(
//                             onPressed: () async {
//                               Navigator.of(context).pop();
//                               DBHandler db = await DBHandler.getInstnace();
//                               await db.deleteFolder(children[i].id);
//                               Navigator.of(context).pop();
//                               // show dialogue to show that folder is deleted !!!
//                               showDialog(
//                                   context: context,
//                                   builder: (cont) {
//                                     return AlertDialog(
//                                       title: const Text('Folder Deleted..'),
//                                       actions: [
//                                         TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text("ok"))
//                                       ],
//                                     );
//                                   });
//                             },
//                             child: const Text("Delete")),
//                       ],
//                     );
//                   });
//             }),
//       ),
//     );
//   }
//   print('exp:::');
//   print(exp);
//   List<Widget> ep = [];
//   ep.addAll(exp);
//   exp.clear();
//   return ep;
// }
