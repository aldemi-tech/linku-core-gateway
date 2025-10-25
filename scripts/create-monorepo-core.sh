#!/bin/bash

# Script para crear la estructura del monorepo core
# Este script debe ejecutarse en una carpeta nueva para el proyecto core

echo "🚀 Creando estructura del monorepo Aldemi Functions Core..."

# 1. Inicializar repo git
git init
echo "✅ Repositorio git inicializado"

# 2. Crear estructura de directorios
mkdir -p packages src scripts .github/workflows docs

# 3. Crear package.json del monorepo
cat > package.json << 'EOF'
{
  "name": "aldemi-functions-core",
  "version": "1.0.0",
  "description": "Monorepo core para todas las Cloud Functions de Aldemi",
  "private": true,
  "scripts": {
    "build": "npm run build:all",
    "build:all": "./scripts/build-all.sh",
    "build:payment": "cd packages/payment && npm run build",
    "build:meet": "cd packages/meet && npm run build",
    "test": "npm run test:all",
    "test:all": "./scripts/test-all.sh",
    "test:payment": "cd packages/payment && npm test",
    "test:meet": "cd packages/meet && npm test",
    "serve": "npm run build:all && firebase emulators:start --only functions",
    "deploy": "./scripts/deploy.sh",
    "deploy:payment": "./scripts/deploy.sh payment",
    "deploy:meet": "./scripts/deploy.sh meet",
    "setup-submodules": "./scripts/setup-submodules.sh",
    "update-submodules": "git submodule update --recursive --remote"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^5.62.0",
    "@typescript-eslint/parser": "^5.62.0",
    "eslint": "^8.57.0",
    "firebase-functions-test": "^3.3.0",
    "jest": "^29.7.0",
    "typescript": "^5.4.5"
  },
  "dependencies": {
    "firebase-admin": "^11.11.0",
    "firebase-functions": "^4.8.1"
  },
  "workspaces": [
    "packages/*"
  ]
}
EOF

echo "✅ Estructura básica creada"
echo ""
echo "🔧 Próximos pasos:"
echo "1. Ejecutar: npm install"
echo "2. Ejecutar: ./scripts/setup-submodules.sh" 
echo "3. Configurar Firebase: firebase init"
echo "4. Agregar submódulos: git submodule add <repo-url> packages/<domain>"