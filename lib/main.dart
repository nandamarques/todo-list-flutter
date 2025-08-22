// main.dart

// A importação do pacote Material Design nos dá acesso a um rico conjunto de widgets
// prontos para usar, como AppBar, Scaffold, FloatingActionButton, etc.
// É semelhante a importar as bibliotecas do AndroidX Material.
import 'package:flutter/material.dart';

// O ponto de entrada da aplicação. A função `main` é a primeira a ser executada.
// Em Java, seria o `public static void main(String[] args)`.
// A função `runApp` infla o widget principal (neste caso, `TodoApp`) e o anexa à tela.
void main() {
  runApp(const TodoApp());
}

// Em Flutter, quase tudo é um Widget. Este é o widget raiz da nossa aplicação.
// É um `StatelessWidget` porque seu estado interno não muda ao longo do tempo.
// Ele apenas define as configurações globais do app, como o tema e a tela inicial.
// Pense nele como a configuração inicial do seu app no `onCreate` da sua Activity principal,
// definindo o tema e qual layout (tela) carregar primeiro.
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // `MaterialApp` é um widget essencial que fornece funcionalidades básicas
    // de uma aplicação Material Design, como navegação, temas, etc.
    return MaterialApp(
      title: 'Todo List (Java Dev to Flutter)',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // `home` define o widget que será exibido como a tela inicial do aplicativo.
      home: const TodoListScreen(),
      debugShowCheckedModeBanner: false, // Remove o banner de "Debug"
    );
  }
}

// Um modelo de dados simples para representar uma tarefa.
// É o equivalente a uma classe POJO (Plain Old Java Object) ou uma data class em Kotlin.
class TodoItem {
  String title;
  bool isDone;

  // Construtor da classe com parâmetros nomeados.
  // `required` indica que `title` é obrigatório.
  // `this.isDone = false` define um valor padrão para `isDone`.
  TodoItem({required this.title, this.isDone = false});
}

// Esta é a nossa tela principal. É um `StatefulWidget` porque o seu conteúdo
// (a lista de tarefas) pode mudar dinamicamente, e a UI precisa ser reconstruída
// para refletir essas mudanças.
// Em Android nativo, uma Activity ou Fragment gerencia seu próprio estado. Aqui, o
// `StatefulWidget` e seu objeto `State` correspondente fazem esse papel.
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  // A principal diferença de um StatefulWidget é que ele cria um objeto `State`.
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

// Esta classe contém o estado (os dados) e a lógica da nossa tela.
// O `_` no início do nome (`_TodoListScreenState`) torna a classe privada para este arquivo.
class _TodoListScreenState extends State<TodoListScreen> {
  // Esta é a "fonte da verdade" para nossa lista de tarefas.
  // É o estado que queremos exibir e modificar. É como ter um `ArrayList<TodoItem>` na sua Activity.
  final List<TodoItem> _todos = [];

  // Controlador para o campo de texto no diálogo de adicionar tarefa.
  // Similar ao `EditText` em Android, o `TextEditingController` nos dá acesso
  // ao texto e outras propriedades do campo.
  final TextEditingController _textFieldController = TextEditingController();

  // Função para adicionar um novo item à lista.
  void _addTodoItem(String title) {
    // Validação simples para não adicionar tarefas vazias.
    if (title.isNotEmpty) {
      // `setState` é a função MAIS IMPORTANTE em um StatefulWidget.
      // Ela notifica o Flutter que o estado interno deste widget mudou.
      // O Flutter então agenda uma reconstrução (chama o método `build` novamente)
      // para que a UI reflita o novo estado.
      // Em Android nativo, você adicionaria o item à sua lista e depois chamaria
      // `adapter.notifyDataSetChanged()` em um RecyclerView. `setState` é a versão do Flutter para isso.
      setState(() {
        _todos.add(TodoItem(title: title));
      });
      // Limpa o campo de texto para a próxima entrada.
      _textFieldController.clear();
    }
  }

  // Função para marcar uma tarefa como concluída ou não.
  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  // Função para remover uma tarefa da lista.
  void _removeTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  // Função para exibir o diálogo de adicionar nova tarefa.
  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // O usuário deve tocar em um botão para fechar.
      builder: (BuildContext context) {
        // `AlertDialog` é um widget para mostrar diálogos, similar ao `AlertDialog.Builder` em Android.
        return AlertDialog(
          title: const Text('Adicionar nova tarefa'),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Digite o título da tarefa'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _textFieldController.clear();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                _addTodoItem(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearAllTasks() async {
    setState(() {
      _todos.clear();
    });
  }

  // O método `build` é o coração de qualquer widget. Ele descreve como o widget
  // deve ser desenhado na tela, com base no estado atual.
  // Ele é chamado sempre que o widget é inserido na árvore de widgets pela primeira vez
  // e sempre que `setState` é chamado.
  // Pense nele como uma mistura do seu arquivo de layout XML e do código `onCreateView` ou `onCreate`,
  // mas executado com muito mais frequência e de forma muito mais eficiente.
  @override
  Widget build(BuildContext context) {
    // `Scaffold` é um widget que implementa a estrutura de layout visual básica do Material Design.
    // Ele fornece APIs para exibir AppBars, Drawers, FloatingActionButtons e o corpo principal da tela (`body`).
    // É o esqueleto da sua tela, como um layout raiz com uma Toolbar e um espaço para o conteúdo.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      // O `body` é o conteúdo principal da tela.
      // Estamos usando um `ListView.builder` que é a forma mais eficiente de criar listas,
      // pois ele só constrói os itens que são visíveis na tela. É o `RecyclerView` do Flutter.
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];

          // `Dismissible` é um widget que permite arrastar um item para dispensá-lo.
          // Muito útil para ações como "arrastar para excluir".
          return Dismissible(
            key: Key(todo.title +
                index.toString()), // Chave única para identificar o widget.
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // Quando o item é arrastado e dispensado, removemos ele da lista.
              _removeTodoItem(index);
              // Mostra uma confirmação temporária na parte inferior da tela.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title} removido')),
              );
            },
            child: CheckboxListTile(
              title: Text(
                todo.title.toLowerCase(),
                style: TextStyle(
                  // Aplica um estilo de texto diferente se a tarefa estiver concluída.
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  color: todo.isDone ? Colors.grey : null,
                ),
              ),
              value: todo.isDone,
              // `onChanged` é um callback, uma função que é passada como argumento para ser
              // executada quando um evento ocorre. É o equivalente ao `setOnCheckedChangeListener`.
              onChanged: (bool? value) {
                _toggleTodoStatus(index);
              },
            ),
          );
        },
      ),
      // `FloatingActionButton` é o botão flutuante, geralmente usado para a ação primária da tela.
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "deletedBtn",
              onPressed: _clearAllTasks,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            ),
            FloatingActionButton(
              heroTag: "addBtn",
              // `onPressed` é o callback para o evento de clique. É o `setOnClickListener` do Flutter.
              onPressed: _displayDialog,
              tooltip: 'Adicionar Tarefa',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
