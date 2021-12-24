import 'package:flutter/material.dart';

class SSTile extends StatelessWidget {
  final dynamic state;

  const SSTile({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      onTap: state.showModal,
      title: Text(
        state.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          state.valueDisplay,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}

class SSModalBuilder extends StatelessWidget {
  final dynamic state;
  final String title;

  const SSModalBuilder({
    Key? key,
    @required this.state,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: state.modalBody,
      ),
    );
  }
}

class SSChoiceBuilder extends StatelessWidget {
  final dynamic state;

  const SSChoiceBuilder({Key? key, @required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(state.title),
          onTap: () => state.select(!state.selected),
          trailing: state.selected ? const Icon(Icons.check) : null,
          dense: true,
          selected: state.selected,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
