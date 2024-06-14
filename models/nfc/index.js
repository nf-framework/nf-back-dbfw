import { NfcRolesOrigin } from './origin/NfcRoles.js';
import { NfcUsersOrigin } from './origin/NfcUsers.js';
import { NfcExSystemsOrigin } from './origin/NfcExSystems.js';
import { NfcExSystemServicesOrigin } from './origin/NfcExSystemServices.js';
import { NfcExSystemMappingOrigin } from './origin/NfcExSystemMapping.js';
import { NfcFilesOrigin } from './origin/NfcFiles.js';
import { NfcUnitFileTypesOrigin } from './origin/NfcUnitFileTypes.js';
import { NfcUnitFilesOrigin } from './origin/NfcUnitFiles.js';
import { NfcRoleUnitprivsOrigin } from './origin/NfcRoleUnitprivs.js';
import { NfcRoleUnitbpprivsOrigin } from './origin/NfcRoleUnitbpprivs.js';
import { NfcMenuRolesOrigin } from './origin/NfcMenuRolesOrigin.js';

export class NfcRoles extends NfcRolesOrigin {}

export class NfcUsers extends NfcUsersOrigin {}

export class NfcExSystems extends NfcExSystemsOrigin {}

export class NfcExSystemServices extends NfcExSystemServicesOrigin {
    static async available(connect, exSystemCode, exSystemServiceCode) {
        const r = await connect.query(`select exists (
select null
  from nfc.v4ex_systems es
       join nfc.v4ex_system_services ess on ess.pid = es.id 
 where es.code = :es_code
   and not es.is_stopped 
   and ess.code = :ess_code
   and not ess.is_stopped) as res`, { es_code: exSystemCode, ess_code: exSystemServiceCode });
        return (r && r.data && r.data[0]) ? r.data[0].res : false;
    }
}

export class NfcExSystemMapping extends NfcExSystemMappingOrigin {}

export class NfcFiles extends NfcFilesOrigin {}

export class NfcUnitFileTypes extends NfcUnitFileTypesOrigin {}

export class NfcUnitFiles extends NfcUnitFilesOrigin {}

export class NfcRoleUnitprivs extends NfcRoleUnitprivsOrigin {
    static async check(connect, unit) {
        const r = await connect.func('nfc.f4role_unitprivs8check', { unit });
        let res = false;
        if (r && r.data && r.data.length > 0 && r.data[0].result === true) res = true;
        return res;
    }
}

export class NfcRoleUnitbpprivs extends NfcRoleUnitbpprivsOrigin {
    static async check(connect, unitbp) {
        const r = await connect.func('nfc.f4role_unitbpprivs8check', { unitbp });
        let res = false;
        if (r && r.data && r.data.length > 0 && r.data[0].result === true) res = true;
        return res;
    }
}

export class NfcMenuRoles extends NfcMenuRolesOrigin {}
