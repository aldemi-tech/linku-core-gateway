#!/bin/bash

# Script de deploy inteligente para monorepo
# Detecta qué dominios cambiaron y despliega solo esos

set -e

DOMAIN=${1:-"auto"}  # Dominio específico o "auto" para detección automática
FORCE_ALL=${2:-false}

echo "🚀 Deploy inteligente iniciado..."

# Función para detectar cambios por dominio
detect_changes() {
    local domain=$1
    local has_changes=false
    
    # Si es el primer commit, deploy todo
    if ! git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
        echo "  ℹ️ Primer commit detectado - desplegando todo"
        echo "true"
        return
    fi
    
    # Detectar cambios en el dominio específico
    if git diff --name-only HEAD~1 HEAD | grep -q "packages/$domain/"; then
        has_changes=true
    fi
    
    # Detectar cambios en shared que afectan a todos
    if git diff --name-only HEAD~1 HEAD | grep -q "src/shared"; then
        has_changes=true
    fi
    
    # Detectar cambios en configuración que afecta a todos
    if git diff --name-only HEAD~1 HEAD | grep -q -E "(package\.json|firebase\.json|tsconfig\.json)"; then
        has_changes=true
    fi
    
    echo $has_changes
}

# Función para deploy de un dominio específico
deploy_domain() {
    local domain=$1
    echo "  🚀 Desplegando funciones de $domain..."
    
    case $domain in
        "payment")
            firebase deploy --only functions:paymentTokenizeCardDirect,functions:paymentCreateTokenizationSession,functions:paymentCompleteTokenization,functions:paymentProcessPayment,functions:paymentRefundPayment,functions:paymentWebhook,functions:paymentGetAvailableProviders,functions:paymentGetExecutionLocation
            ;;
        "meet")
            firebase deploy --only functions:meetCreateMeeting,functions:meetUpdateMeeting,functions:meetDeleteMeeting,functions:meetListMeetings
            ;;
        "shared")
            firebase deploy --only functions:healthCheck
            ;;
        *)
            echo "  ❌ Dominio desconocido: $domain"
            exit 1
            ;;
    esac
    
    echo "  ✅ Deploy de $domain completado"
}

# Función principal
main() {
    echo "🔍 Analizando cambios..."
    
    if [ "$DOMAIN" = "auto" ]; then
        # Modo automático - detectar qué cambió
        domains_to_deploy=()
        
        for domain in payment meet; do
            if [ -d "packages/$domain" ]; then
                changes=$(detect_changes $domain)
                if [ "$changes" = "true" ]; then
                    domains_to_deploy+=($domain)
                    echo "  📦 Cambios detectados en: $domain"
                fi
            fi
        done
        
        # Verificar si shared cambió (afecta a todos)
        shared_changes=$(git diff --name-only HEAD~1 HEAD | grep -q "src/shared" && echo "true" || echo "false")
        if [ "$shared_changes" = "true" ]; then
            domains_to_deploy+=("shared")
            echo "  🔧 Cambios detectados en: shared"
        fi
        
        if [ ${#domains_to_deploy[@]} -eq 0 ]; then
            echo "  ℹ️ No se detectaron cambios en dominios - saltando deploy"
            exit 0
        fi
        
        echo "📋 Dominios a desplegar: ${domains_to_deploy[*]}"
        
    elif [ "$DOMAIN" = "all" ] || [ "$FORCE_ALL" = "true" ]; then
        # Deploy de todo
        echo "🌐 Deploy completo solicitado"
        domains_to_deploy=(payment meet shared)
        
    else
        # Deploy de dominio específico
        echo "🎯 Deploy específico de: $DOMAIN"
        domains_to_deploy=($DOMAIN)
    fi
    
    # Ejecutar build antes del deploy
    echo "🔨 Ejecutando build..."
    npm run build:all
    
    # Deploy de cada dominio
    for domain in "${domains_to_deploy[@]}"; do
        deploy_domain $domain
    done
    
    echo "🎉 Deploy completado exitosamente!"
}

# Validaciones iniciales
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI no está instalado"
    exit 1
fi

if ! firebase projects:list | grep -q "$(firebase use --current 2>/dev/null)"; then
    echo "❌ No hay un proyecto Firebase activo"
    echo "   Ejecuta: firebase use <project-id>"
    exit 1
fi

# Ejecutar función principal
main