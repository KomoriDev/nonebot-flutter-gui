import 'dart:convert';

import 'package:NoneBotGUI/darts/utils.dart';
import 'package:NoneBotGUI/ui/managecli.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:NoneBotGUI/ui/stderr.dart';
import 'package:NoneBotGUI/darts/global.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: ManageBot(),
//     );
//   }
// }

class ManageBot extends StatefulWidget {
  const ManageBot({super.key});
  @override
  State<ManageBot> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<ManageBot> {
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();


  @override
  void initState() {
    getDir();
    super.initState();
    _loadFileContent();
    _startRefreshing();
  }

  String getDir() {
    return userDir;
  }


  void _startRefreshing() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _loadFileContent(),
    );
  }

  void _loadFileContent() async {
    File stdoutFile = File(_filePath);
    if (stdoutFile.existsSync()) {
      try {
        File file = File(_filePath);
        final lines = await file.readAsLines(encoding: systemEncoding);
        final last50Lines =
            lines.length > 50 ? lines.sublist(lines.length - 50) : lines;
        setState(() {
          _log = last50Lines.join('\n');
          getPyPid(userDir);
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void _reloadConfig() {
    setState(() {
      getPyPid(userDir);
      _filePath = '${manageBotReadCfgPath(userDir)}/nbgui_stdout.log';
      _scrollController.addListener(() {
     });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
    });
  }

  String name = manageBotReadCfgName(userDir);
  String _filePath = '${manageBotReadCfgPath(userDir)}/nbgui_stdout.log';
  String _log = '[INFO]Welcome to Nonebot GUI!\n';
  @override
  Widget build(BuildContext context) {
  Future.delayed(Duration.zero, () {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  });
  final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
              SizedBox(
                width: size.width * 0.3,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Bot信息',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '名称',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            manageBotReadCfgName(userDir),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '路径',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            manageBotReadCfgPath(userDir),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '创建时间',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            manageBotReadCfgTime(userDir),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '进程ID(Nonebot)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            manageBotReadCfgPid(userDir),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '进程ID(Python)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            manageBotReadCfgPyPid(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '状态',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      if (manageBotReadCfgStatus(userDir) == 'true')
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '运行中',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                      if (manageBotReadCfgStatus(userDir) == 'false')
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '未运行',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: OutlinedButton(
                          child: const Icon(Icons.edit_rounded),
                          onPressed: () {
                            setState(() {
                              name = manageBotReadCfgName(userDir);
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('编辑Bot属性'),
                                  actions: <Widget>[
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Column(
                                          children: <Widget>[
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('重命名Bot'),
                                            ),
                                            TextField(
                                              controller: TextEditingController(),
                                              decoration: InputDecoration(
                                                hintText: name,
                                              ),
                                              style: const TextStyle(color: Colors.white),
                                              onChanged: (value){
                                                setState(() => name = value);
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      child: const Text(
                                        '保存',
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        if (name != manageBotReadCfgName(userDir)){
                                          renameBot(name);
                                          setState(() {
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: OutlinedButton(
                          child: const Icon(Icons.delete_rounded),
                          onPressed: () => _showConfirmationDialog(context),
                        ),
                      )
                    ],
                  )
                ),
              ),
            Expanded(
                child: Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '控制台输出',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          width: size.width * 0.65,
                          height: size.height * 0.75,
                          child: Card(
                            color: const Color.fromARGB(255, 31, 28, 28),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JetBrainsMono',
                                    ),
                                    children: _logSpans(nbLog),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Expanded(
                    child: Card(
                      child: Column(
                    children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '操作',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  if (manageBotReadCfgStatus(userDir) == 'false') {
                                    runBot(userDir, manageBotReadCfgPath(userDir));
                                    _reloadConfig();
                                    _startRefreshing();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Nonebot,启动！如果发现控制台无刷新请检查bot目录下的nbgui_stderr.log查看报错',
                                        ),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bot已经在运行中了！'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                tooltip: "运行",
                                icon: const Icon(Icons.play_arrow_rounded),
                                iconSize: size.height * 0.03,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (manageBotReadCfgStatus(userDir) == 'true') {
                                    stopBot(userDir);
                                    _startRefreshing();
                                    _reloadConfig();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bot已停止'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bot未在运行！'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                tooltip: "停止",
                                icon: const Icon(Icons.stop_rounded),
                                iconSize: size.height * 0.03,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (manageBotReadCfgStatus(userDir) == 'true') {
                                    stopBot(userDir);
                                    runBot(userDir, manageBotReadCfgPath(userDir));
                                    clearLog(userDir);
                                    _reloadConfig();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bot正在重启...'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Bot未在运行！'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                tooltip: "重启",
                                icon: const Icon(Icons.refresh),
                                iconSize: size.height * 0.03,
                              ),
                              IconButton(
                                onPressed: () =>
                                    openFolder(manageBotReadCfgPath(userDir).toString()),
                                tooltip: "打开文件夹",
                                icon: const Icon(Icons.folder),
                                iconSize: size.height * 0.03,
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const manageCli(),
                                  ),
                                ),
                                tooltip: "管理CLI",
                                icon: const Icon(Icons.terminal_rounded),
                                iconSize: size.height * 0.03,
                              ),
                              IconButton(
                                onPressed: () {
                                  clearLog(userDir);
                                },
                                tooltip: "清空日志",
                                icon: const Icon(Icons.delete_rounded),
                                iconSize: size.height * 0.03,
                              ),
                              Visibility(
                                visible: File('${manageBotReadCfgPath(userDir)}/nbgui_stderr.log').readAsStringSync(encoding: systemEncoding).isNotEmpty,
                                child: IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StdErr(),
                                    ),
                                  ),
                                  tooltip: '查看报错日志',
                                  icon: const Icon(Icons.error_rounded),
                                  color: Colors.red,
                                  iconSize: size.height * 0.04,
                                ),
                              ),
                            ],
                          ),
                      )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

///终端字体颜色
//这一段AI写的我什么也不知道😭
List<TextSpan> _logSpans(text) {
  RegExp regex = RegExp(
    r'(\[[A-Z]+\])|(nonebot \|)|(uvicorn \|)|(Env: dev)|(Env: prod)|(Config)|(nonebot_plugin_[\S]+)|("nonebot_plugin_[\S]+)|(使用 Python: [\S]+)|(Loaded adapters: [\S]+)|(\d{2}-\d{2} \d{2}:\d{2}:\d{2})|(Calling API [\S]+)',
  );
  List<TextSpan> spans = [];
  int lastEnd = 0;

  for (Match match in regex.allMatches(text)) {
    if (match.start > lastEnd) {
      spans.add(TextSpan(
        text: text.substring(lastEnd, match.start),
        style: const TextStyle(color: Colors.white),
      ));
    }

    Color color;
    switch (match.group(0)) {
      case '[SUCCESS]':
        color = Colors.greenAccent;
        break;
      case '[INFO]':
        color = Colors.white;
        break;
      case '[WARNING]':
        color = Colors.orange;
        break;
      case '[ERROR]':
        color = Colors.red;
        break;
      case '[DEBUG]':
        color = Colors.blue;
        break;
      case 'nonebot |':
        color = Colors.green;
        break;
      case 'uvicorn |':
        color = Colors.green;
        break;
      case 'Env: dev':
        color = Colors.orange;
        break;
      case 'Env: prod':
        color = Colors.orange;
        break;
      case 'Config':
        color = Colors.orange;
        break;
      default:
        if (match.group(0)!.startsWith('nonebot_plugin_')) {
          color = Colors.yellow;
        } else if (match.group(0)!.startsWith('"nonebot_plugin_')) {
          color = Colors.yellow;
        } else if (match.group(0)!.startsWith('Loaded adapters:')) {
          color = Colors.greenAccent;
        } else if (match.group(0)!.startsWith('使用 Python:')) {
          color = Colors.greenAccent;
        } else if (match.group(0)!.startsWith('Calling API')) {
          color = Colors.purple;
        } else if (match.group(0)!.contains('-') &&
            match.group(0)!.contains(':')) {
          color = Colors.green;
        } else {
          color = Colors.white;
        }
        break;
    }

    spans.add(TextSpan(
      text: match.group(0),
      style: TextStyle(color: color),
    ));

    lastEnd = match.end;
  }
  if (lastEnd < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastEnd),
      style: const TextStyle(color: Colors.white),
    ));
  }

  return spans;
}



void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('删除'),
        content: const Text('你确定要删除这个Bot吗？'),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              '确定',
              style: TextStyle(color: Color.fromRGBO(238, 109, 109, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (manageBotReadCfgStatus(userDir)=='true'){
                stopBot(userDir);
              }
              deleteBot(userDir);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Bot已删除'),
                duration: Duration(seconds: 3),
              ));
            },
          ),
          TextButton(
            child: const Text(
              '确定（连同bot目录一起删除）',
              style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (manageBotReadCfgStatus(userDir)=='true'){
                stopBot(userDir);
              }
              deleteBotAll(userDir);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Bot已删除'),
                duration: Duration(seconds: 3),
              ));
            },
          ),
        ],
      );
    },
  );
}