import * as testing from '../modelgen.js';

describe('@nfjs/back-dbfw/lib/modelgen', () => {
    describe('script', () => {
        it('check', async () => {
            // Arrange
            // Act
            const res = await testing.script('nfc.users');
            // Assert
        });
    });
    describe('gen', () => {
        it('check', async () => {
            // Arrange
            // Act
            const res = await testing.gen('nfc.users');
            // Assert
        });
    });
});
