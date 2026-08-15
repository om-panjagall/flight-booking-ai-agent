#!/bin/bash

echo "Creating Flutter Clean Architecture..."

# Root folders
mkdir -p lib/core
mkdir -p lib/shared
mkdir -p lib/features

####################################
# CORE
####################################

mkdir -p lib/core/config
mkdir -p lib/core/constants
mkdir -p lib/core/theme
mkdir -p lib/core/router
mkdir -p lib/core/network
mkdir -p lib/core/storage
mkdir -p lib/core/utils
mkdir -p lib/core/widgets
mkdir -p lib/core/di

####################################
# SHARED
####################################

mkdir -p lib/shared/models
mkdir -p lib/shared/widgets
mkdir -p lib/shared/extensions
mkdir -p lib/shared/helpers

####################################
# FEATURE CREATOR
####################################

create_feature() {

FEATURE=$1

mkdir -p lib/features/$FEATURE/data/datasources
mkdir -p lib/features/$FEATURE/data/models
mkdir -p lib/features/$FEATURE/data/repositories

mkdir -p lib/features/$FEATURE/domain/entities
mkdir -p lib/features/$FEATURE/domain/repositories
mkdir -p lib/features/$FEATURE/domain/usecases

mkdir -p lib/features/$FEATURE/presentation/controllers
mkdir -p lib/features/$FEATURE/presentation/screens
mkdir -p lib/features/$FEATURE/presentation/widgets

touch lib/features/$FEATURE/data/datasources/${FEATURE}_remote_datasource.dart
touch lib/features/$FEATURE/data/models/${FEATURE}_model.dart
touch lib/features/$FEATURE/data/repositories/${FEATURE}_repository_impl.dart

touch lib/features/$FEATURE/domain/entities/${FEATURE}.dart
touch lib/features/$FEATURE/domain/repositories/${FEATURE}_repository.dart
touch lib/features/$FEATURE/domain/usecases/get_${FEATURE}.dart

touch lib/features/$FEATURE/presentation/controllers/${FEATURE}_controller.dart
touch lib/features/$FEATURE/presentation/screens/${FEATURE}_screen.dart

}

####################################
# FEATURES
####################################

create_feature auth
create_feature home
create_feature airports
create_feature flights
create_feature booking
create_feature passenger
create_feature payment
create_feature ticket
create_feature ai

####################################
# CORE FILES
####################################

touch lib/main.dart

touch lib/core/config/app_config.dart

touch lib/core/constants/api_constants.dart
touch lib/core/constants/app_constants.dart

touch lib/core/theme/app_theme.dart

touch lib/core/router/app_router.dart

touch lib/core/network/api_client.dart
touch lib/core/network/network_exception.dart

touch lib/core/storage/local_storage.dart

touch lib/core/utils/logger.dart
touch lib/core/utils/validators.dart

touch lib/core/di/injection.dart

####################################
# SHARED FILES
####################################

touch lib/shared/widgets/loading_widget.dart
touch lib/shared/widgets/error_widget.dart
touch lib/shared/helpers/result.dart
touch lib/shared/extensions/context_extension.dart

echo ""
echo "Flutter Clean Architecture Created Successfully."