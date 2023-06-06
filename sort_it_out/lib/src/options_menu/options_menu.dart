import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sort_it_out/src/save_data/save_data_provider.dart';

class OptionsMenu extends StatefulWidget {
  const OptionsMenu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Consumer<SaveDataProvider>(
          builder: ((context, saveProvider, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Bubble Sort'),
                    TextButton(
                        child: const Text('Apagar dados de progresso salvos'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Cuidado!'),
                                    content: const Text(
                                        'Você realmente deseja resetar seus dados salvos?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          saveProvider.resetSaveData();
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('Sim'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Canceled');
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                    ],
                                  ));
                        },
                        style: Theme.of(context).textButtonTheme.style),
                    if (saveProvider.saveData != null)
                      TextButton(
                          child: const Text(
                              'Localizar seu arquivo de dados de progresso'),
                          onPressed: () async {
                            String saveFilePath = '';
                            saveFilePath = await saveProvider.getFilePath();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Localização'),
                                      content: Text(
                                          'Seu arquivo está localizado no diretório: $saveFilePath'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ));
                          },
                          style: Theme.of(context).textButtonTheme.style),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
