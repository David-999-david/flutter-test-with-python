import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVerifyLoading extends ConsumerStatefulWidget{
  const EmailVerifyLoading({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailVerifyLoadingState();
}

class _EmailVerifyLoadingState extends ConsumerState<EmailVerifyLoading> {
   @override
  Widget build(BuildContext context) {
    return Scaffold();
}
}