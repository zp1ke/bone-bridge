import 'package:flutter/material.dart';

class PublicProfilePage extends StatefulWidget {
  final String username;

  const PublicProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 850),
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Text(
      widget.username,
      textScaler: const TextScaler.linear(0.6),
      style: TextStyle(
        color: Theme.of(context).disabledColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget body() {
    return ListView(
      children: [
        headerCard(),
      ].map((item) => card(child: item)).toList(),
    );
  }

  Widget headerCard() {
    return const Text('HEADER');
  }

  Widget card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: child,
        ),
      ),
    );
  }
}
