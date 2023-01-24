import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final String initialValue;

  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      //언제 실행? 텍스트 폼필드를 감싸고 있는 상위 폼에서 세이브함수를 불렀을 때 실행
      onSaved: onSaved,
      //null이 리턴되면 에러가 없다.
      //에러가 있으면 에러를 string 값으로 리턴해준다.
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해 주세요';
        }

        if (isTime) {
          int time = int.parse(val);
          if (time < 0) {
            return '0이상의 숫자를 입력해 주세요';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해 주세요';
          }
        } else {
          if (val.length > 500) {
            return '500자 이하의 글자를 입력해 주세요';
          }
        }

        return null;
      },

      expands: !isTime,
      initialValue: initialValue,
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
