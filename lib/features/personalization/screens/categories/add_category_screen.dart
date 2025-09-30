import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../shop/controllers/category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({Key? key}) : super(key: key);

  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une catégorie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _categoryController.formKey,
          child: Column(
            children: [
              Obx(() {
                final imageFile = _categoryController.pickedImage.value;
                return GestureDetector(
                  onTap: _categoryController.pickImage,
                  child: imageFile != null
                      ? Image.file(
                          imageFile,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          TImages.coffee,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                );
              }),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: _categoryController.pickImage,
                icon: Icon(Icons.image),
                label: Text('Choisir une image'),
              ),
              TextFormField(
                controller: _categoryController.nameController,
                decoration: InputDecoration(labelText: 'Nom de la catégorie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController.parentIdController,
                decoration: InputDecoration(
                    labelText: 'ID de la catégorie parente (optionnel)'),
              ),
              Obx(() => CheckboxListTile(
                    title: Text('Catégorie en vedette'),
                    value: _categoryController.isFeatured.value,
                    onChanged: (val) {
                      _categoryController.isFeatured.value = val ?? false;
                    },
                  )),
              SizedBox(height: 20),
              Obx(() => _categoryController.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _categoryController.addCategory,
                      child: Text('Ajouter'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
