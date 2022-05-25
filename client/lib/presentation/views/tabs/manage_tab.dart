import 'package:flutter/material.dart';


class ManageTab extends StatefulWidget {
  const ManageTab({Key? key}) : super(key: key);

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // length of tabs
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black45,
                  tabs: [
                    Tab(text: 'Approval'),
                    Tab(text: 'Employee'),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    //height of TabBarView
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Theme.of(context).primaryColor, width: 0.5))),
                    child: TabBarView(children: <Widget>[
                      ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 170,
                              child: Card(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.teal.withAlpha(30),
                                        onTap: () {},
                                        child: ListTile(
                                          isThreeLine: true,
                                          minVerticalPadding: 15,
                                          title: Text('Time Sheet 04/2022'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Employee's Name: "),
                                              Text("General Coming:"),
                                              Text("OverTime:"),
                                              Text("Leave:")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width/2-10 ,
                                            child: TextButton(
                                              child: const Text('APPROVE'),
                                              onPressed: () {/* ... */},
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width/2-10,
                                            child: TextButton(
                                              child: const Text('DECLINE',style: TextStyle(color: Colors.red),),
                                              onPressed: () {/* ... */},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            );
                          }),
                      ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Card(
                                child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('Card tapped.');
                              },
                              child: ListTile(
                                leading:
                                    Image.network('https://i.pravatar.cc/201'),
                                title: Text('Dũng'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Employee'),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ));
                          }),
                    ])),
              )
            ]));
  }
}
