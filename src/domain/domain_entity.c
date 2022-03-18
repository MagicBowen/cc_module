#include "domain_entity.h"
#include "domain_state.h"
#include "infra_log.h"

EntityId Domain_GetEntityId() {
    if (!DOMAIN_INITIALIZED) {
        return 1;
    }
    INFRA_LOG("domain has not been initialized!\n");
    return 0;
}