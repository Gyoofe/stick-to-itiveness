import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:animatedimagemaker/utilities/keys.dart';

class SearchBarMain extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Video'),
      ),
      body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular((5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SearchField(),
          )
      ),
    );
  }
}


class SearchBar extends StatelessWidget
{
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: SearchField(),
      )
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({Key key}) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final m_controller = TextEditingController();
  final m_forcusNode = FocusNode();
  YoutubeAPI ytApi = YoutubeAPI(API_KEY);
  List<YT_API> ytResult = [];

  void initState(){
    super.initState();
    m_forcusNode.addListener(() {
      if(m_forcusNode.hasFocus){
        m_controller.selection = TextSelection(baseOffset:  0, extentOffset: m_controller.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    callAPI(String _query) async{
      ytResult = await ytApi.search(_query);
      //ytResult = await ytApi.nextPage();
      setState(() {});
    }

    return
      Column(
        children:<Widget>[Row(
            children:<Widget>[
              Flexible(
                child:TextField(
                  decoration: InputDecoration(
                    hintText: 'search videos',
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  onSubmitted: (searchQuery){
                  },
                  controller: m_controller,
                  focusNode: m_forcusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => {callAPI(m_controller.text)},
                ),
              )
          ]),
          Flexible(
              child:ListView.builder(
                itemCount: ytResult.length,
                itemBuilder: (_, int index) => videoItem(index),
              ),
          )
      ]);
  }

  Widget videoItem(index){
    return Card(
      child: new InkWell(
        onTap: (){
          Navigator.pop(context, ytResult[index].id);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Image.network(
                ytResult[index].thumbnail['default']['url'],
              ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ytResult[index].title,
                          softWrap: true,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 1.5)),
                        Text(
                          ytResult[index].channelTitle,
                          softWrap: true,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 3.0)),
                        Text(
                          ytResult[index].url,
                          softWrap: true,
                        ),
                      ]))
            ],
          )
        )
      )
    );
  }
}
