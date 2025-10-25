#!/bin/bash

# Script para reestructurar el proyecto payment gateway como submódulo
# Este script prepara el proyecto actual para ser usado como submódulo

echo "🚀 Reestructurando linku-payment-gateway como submódulo..."

# 1. Crear estructura de submódulo
mkdir -p src/functions
mv src/index.ts src/functions/
mv src/providers src/functions/
mv src/types src/functions/
mv src/utils src/functions/
mv src/config src/functions/
mv src/__tests__ src/functions/

# 2. Crear archivo de exportación principal
cat > src/index.ts << 'EOF'
/**
 * Payment Gateway Functions Export
 * Exports all payment-related cloud functions
 */

// Import all functions from the functions directory
export * from './functions/index';
EOF

# 3. Actualizar el index principal para usar la nueva estructura
echo "✅ Reestructuración completada!"
echo "📁 Nueva estructura:"
echo "   src/"
echo "   ├── index.ts (exportador principal)"
echo "   └── functions/"
echo "       ├── index.ts (funciones payment)"
echo "       ├── providers/"
echo "       ├── types/"
echo "       ├── utils/"
echo "       ├── config/"
echo "       └── __tests__/"
echo ""
echo "🔧 Próximos pasos:"
echo "1. Revisar y ajustar las funciones en src/functions/index.ts"
echo "2. Actualizar los imports en los tests"
echo "3. Probar que todo compile correctamente"