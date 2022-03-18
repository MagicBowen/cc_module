#include "service_entity.h"
#include "infra_log.h"

int main() {
    EntityId id = Service_GetEntityId();
    INFRA_LOG("id = %d\n", id);
    return 0;
}