#include "service_entity.h"
#include "domain_entity.h"

EntityId Service_GetEntityId() {
    return Domain_GetEntityId();
}