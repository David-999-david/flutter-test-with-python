import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testflutt/data/model/category_sub_cate.dart';
import 'package:testflutt/data/model/project_model.dart';
import 'package:testflutt/presentation/home/home_state.dart';
import 'package:testflutt/text_app.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Category? selectedCategory;
  SubCategory? selecgedSub;

  void onChanged(Category value) {
    setState(() {
      selectedCategory = value;
      selecgedSub = null;
    });
  }

  void onChangedSub(SubCategory value) {
    setState(() {
      selecgedSub = value;
    });
  }

  final titlec = TextEditingController();
  final descpc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cateState = ref.watch(categoryProvider(''));
    final subState = ref.watch(SubProvider(''));
    final pickedImage = ref.watch(ImagePickerProvider);

    final hadImage = pickedImage != null;

    dynamic bg = hadImage
        ? FileImage(File(pickedImage.path))
        : AssetImage('assets/images/cc2.png');

    final allsub = subState.value ?? <SubCategory>[];

    final filteredSub = selectedCategory == null
        ? <SubCategory>[]
        : allsub.where((s) => s.categoryId == selectedCategory!.id).toList();

    ref.listen(ProjectProvider, (prev, next) {
      next.when(
        data: (data) {
          titlec.clear();
          descpc.clear();
          ref.read(ImagePickerProvider.notifier).clear();
          setState(() {
            selectedCategory = null;
            filteredSub.clear();
          });
        },
        error: (error, _) {},
        loading: () {},
      );
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: bg, fit: BoxFit.cover),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(ImagePickerProvider.notifier)
                            .onPickImage(ImageSource.gallery);
                      },
                      child: Text('Gallery', style: 14.sp()),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(ImagePickerProvider.notifier)
                            .onPickImage(ImageSource.camera);
                      },
                      child: Text('Camera', style: 14.sp()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    cateState.isLoading
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          )
                        : cateDropdown(
                            cateState.value!,
                            selectedCategory,
                            onChanged,
                          ),
                    SizedBox(width: 10),
                    subState.isLoading
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          )
                        : subDropDown(
                            filteredSub,
                            selecgedSub,
                            onChangedSub,
                            enable:
                                selectedCategory != null &&
                                filteredSub.isNotEmpty,
                          ),
                  ],
                ),
              ),
              (selectedCategory == null)
                  ? SizedBox.shrink()
                  : Chip(
                      backgroundColor: Colors.red,
                      label: Text(
                        selectedCategory!.name.toUpperCase(),
                        style: 14.sp(color: Colors.white),
                      ),
                    ),
              (selecgedSub == null)
                  ? SizedBox.shrink()
                  : Chip(
                      backgroundColor: Colors.blue,
                      label: Text(
                        selecgedSub!.name.toUpperCase(),
                        style: 14.sp(color: Colors.white),
                      ),
                    ),
              SizedBox(height: 20),
              textfield(titlec, 'Title', 'Title', 1),
              SizedBox(height: 10),
              textfield(descpc, 'Description', 'Description', 3),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(ProjectProvider.notifier)
                        .create(
                          insertProject(
                            title: titlec.text,
                            description: descpc.text,
                            sub_id: selecgedSub!.id,
                          ),
                          pickedImage,
                        );
                  },
                  child: Text('Confirm', style: 14.sp()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cateDropdown(
  List<Category> cs,
  Category? selected,
  ValueChanged<Category> onChanged,
) {
  return Expanded(
    child: DropdownSearch<Category>(
      items: (filter, loadProps) {
        if (filter.isNotEmpty) {
          return cs
              .where((c) => c.name.toLowerCase().contains(filter))
              .toList();
        } else {
          return cs;
        }
      },
      selectedItem: selected,
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) return SizedBox.shrink();
        return Text(selectedItem.name, style: 14.sp());
      },
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: 'Category',
          hintStyle: 14.sp(),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: 13.sp(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          return ListTile(
            selected: isSelected,
            title: Text(item.name.toUpperCase(), style: 14.sp()),
          );
        },
        emptyBuilder: (context, searchEntry) {
          return Text('No categories found');
        },
        loadingBuilder: (context, searchEntry) {
          return CircularProgressIndicator();
        },
      ),
      itemAsString: (item) {
        return item.name.toString();
      },
      compareFn: (item1, item2) => item1.id == item2.id,
    ),
  );
}

Widget subDropDown(
  List<SubCategory> subs,
  SubCategory? selected,
  ValueChanged<SubCategory> onChanged, {
  bool enable = true,
}) {
  return Expanded(
    child: DropdownSearch<SubCategory>(
      items: (filter, loadProps) {
        if (filter.isEmpty) return subs;
        return subs
            .where((s) => s.name.toLowerCase().contains(filter))
            .toList();
      },
      enabled: enable,
      selectedItem: selected,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) return SizedBox.shrink();
        return Text(selectedItem.name, style: 14.sp());
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: 'Sub-category',
          hintStyle: 14.sp(),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: 14.sp(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          return ListTile(
            selected: isSelected,
            title: Text(item.name.toUpperCase(), style: 14.sp()),
          );
        },
        emptyBuilder: (context, searchEntry) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sub-cateogry is Empty', style: 13.sp()),
          );
        },
        loadingBuilder: (context, searchEntry) {
          return CircularProgressIndicator();
        },
      ),
      itemAsString: (item) => item.name.toString(),
      compareFn: (item1, item2) => item1.id == item2.id,
    ),
  );
}

Widget textfield(TextEditingController c, String hint, String label, int line) {
  return TextFormField(
    maxLines: line,
    controller: c,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: 14.sp(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return '$label cant be empty';
      return null;
    },
  );
}
