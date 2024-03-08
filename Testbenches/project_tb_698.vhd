-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_698 is
end project_tb_698;

architecture project_tb_arch_698 of project_tb_698 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 585;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (76,0,116,0,0,0,0,0,51,0,221,0,209,0,212,0,0,0,18,0,232,0,32,0,0,0,47,0,157,0,0,0,124,0,229,0,69,0,211,0,0,0,50,0,0,0,0,0,200,0,1,0,122,0,0,0,111,0,28,0,20,0,0,0,31,0,226,0,140,0,113,0,156,0,78,0,20,0,101,0,61,0,58,0,46,0,0,0,74,0,56,0,184,0,152,0,76,0,67,0,101,0,36,0,22,0,174,0,0,0,203,0,0,0,110,0,119,0,0,0,0,0,68,0,151,0,81,0,0,0,240,0,102,0,134,0,212,0,0,0,34,0,243,0,17,0,170,0,196,0,101,0,178,0,155,0,0,0,230,0,214,0,0,0,63,0,0,0,132,0,0,0,0,0,35,0,205,0,0,0,188,0,0,0,0,0,252,0,0,0,0,0,0,0,212,0,63,0,229,0,186,0,169,0,116,0,197,0,0,0,0,0,26,0,149,0,0,0,117,0,0,0,60,0,211,0,0,0,0,0,236,0,255,0,0,0,0,0,121,0,0,0,182,0,76,0,197,0,78,0,211,0,0,0,197,0,104,0,0,0,105,0,194,0,193,0,138,0,0,0,170,0,49,0,30,0,252,0,238,0,13,0,200,0,64,0,29,0,110,0,249,0,162,0,40,0,61,0,83,0,187,0,197,0,248,0,0,0,0,0,106,0,49,0,0,0,123,0,83,0,157,0,147,0,23,0,33,0,52,0,168,0,33,0,0,0,0,0,42,0,223,0,198,0,211,0,116,0,34,0,108,0,58,0,87,0,0,0,82,0,233,0,164,0,17,0,171,0,128,0,254,0,187,0,43,0,196,0,211,0,185,0,142,0,146,0,46,0,240,0,39,0,5,0,224,0,0,0,51,0,0,0,204,0,251,0,0,0,51,0,96,0,42,0,0,0,249,0,189,0,0,0,140,0,209,0,197,0,23,0,234,0,184,0,37,0,252,0,88,0,77,0,31,0,0,0,85,0,8,0,167,0,168,0,0,0,86,0,180,0,126,0,234,0,156,0,0,0,125,0,0,0,74,0,120,0,40,0,0,0,164,0,95,0,139,0,227,0,212,0,0,0,85,0,83,0,69,0,0,0,0,0,85,0,17,0,166,0,76,0,228,0,0,0,188,0,0,0,0,0,0,0,174,0,41,0,96,0,53,0,170,0,8,0,201,0,31,0,0,0,23,0,157,0,184,0,4,0,208,0,111,0,0,0,0,0,151,0,251,0,66,0,144,0,0,0,125,0,130,0,114,0,189,0,73,0,10,0,169,0,58,0,179,0,135,0,61,0,15,0,1,0,0,0,105,0,176,0,227,0,55,0,72,0,245,0,53,0,51,0,110,0,176,0,7,0,0,0,100,0,201,0,242,0,41,0,154,0,104,0,106,0,0,0,239,0,22,0,223,0,0,0,251,0,231,0,197,0,0,0,82,0,254,0,125,0,0,0,249,0,212,0,86,0,249,0,39,0,76,0,0,0,0,0,125,0,155,0,148,0,72,0,201,0,160,0,0,0,113,0,48,0,109,0,200,0,103,0,247,0,150,0,0,0,21,0,243,0,85,0,160,0,158,0,0,0,22,0,97,0,0,0,29,0,42,0,79,0,205,0,82,0,207,0,26,0,138,0,239,0,227,0,114,0,8,0,202,0,130,0,205,0,0,0,27,0,0,0,0,0,182,0,0,0,128,0,172,0,204,0,8,0,222,0,129,0,202,0,215,0,181,0,0,0,191,0,53,0,220,0,181,0,0,0,104,0,125,0,49,0,89,0,115,0,237,0,22,0,188,0,0,0,71,0,0,0,2,0,155,0,229,0,58,0,150,0,196,0,249,0,115,0,199,0,34,0,0,0,0,0,0,0,34,0,188,0,0,0,112,0,70,0,0,0,55,0,185,0,189,0,191,0,247,0,129,0,36,0,165,0,10,0,243,0,174,0,0,0,132,0,182,0,165,0,154,0,62,0,23,0,106,0,19,0,0,0,158,0,128,0,60,0,85,0,149,0,73,0,108,0,0,0,236,0,235,0,0,0,0,0,105,0,149,0,0,0,87,0,161,0,142,0,68,0,85,0,0,0,50,0,123,0,186,0,247,0,145,0,0,0,155,0,208,0,81,0,15,0,0,0,0,0,44,0,0,0,71,0,48,0,201,0,18,0,45,0,0,0,146,0,69,0,72,0,176,0,195,0,66,0,66,0,154,0,69,0,0,0,172,0,3,0,0,0,0,0,44,0,0,0,211,0,221,0,232,0,0,0,0,0,105,0,99,0,20,0,77,0,57,0,213,0,9,0,0,0,0,0,176,0,127,0,19,0,185,0,143,0,0,0,120,0,218,0,120,0,78,0,223,0,0,0,150,0,113,0,191,0,193,0,166,0,10,0,178,0,0,0,66,0,103,0,17,0,0,0,0,0,198,0,47,0,55,0,43,0,0,0,248,0,83,0,158,0,200,0,0,0,0,0,247,0,0,0,219,0,35,0,206,0,211,0,0,0,219,0,108,0,234,0,26,0,81,0,81,0,199,0,166,0,70,0,158,0,0,0,0,0,159,0,251,0,118,0,192,0,0,0,251,0,166,0,66,0,60,0,106,0,219,0);
signal scenario_full  : scenario_type := (76,31,116,31,116,30,116,29,51,31,221,31,209,31,212,31,212,30,18,31,232,31,32,31,32,30,47,31,157,31,157,30,124,31,229,31,69,31,211,31,211,30,50,31,50,30,50,29,200,31,1,31,122,31,122,30,111,31,28,31,20,31,20,30,31,31,226,31,140,31,113,31,156,31,78,31,20,31,101,31,61,31,58,31,46,31,46,30,74,31,56,31,184,31,152,31,76,31,67,31,101,31,36,31,22,31,174,31,174,30,203,31,203,30,110,31,119,31,119,30,119,29,68,31,151,31,81,31,81,30,240,31,102,31,134,31,212,31,212,30,34,31,243,31,17,31,170,31,196,31,101,31,178,31,155,31,155,30,230,31,214,31,214,30,63,31,63,30,132,31,132,30,132,29,35,31,205,31,205,30,188,31,188,30,188,29,252,31,252,30,252,29,252,28,212,31,63,31,229,31,186,31,169,31,116,31,197,31,197,30,197,29,26,31,149,31,149,30,117,31,117,30,60,31,211,31,211,30,211,29,236,31,255,31,255,30,255,29,121,31,121,30,182,31,76,31,197,31,78,31,211,31,211,30,197,31,104,31,104,30,105,31,194,31,193,31,138,31,138,30,170,31,49,31,30,31,252,31,238,31,13,31,200,31,64,31,29,31,110,31,249,31,162,31,40,31,61,31,83,31,187,31,197,31,248,31,248,30,248,29,106,31,49,31,49,30,123,31,83,31,157,31,147,31,23,31,33,31,52,31,168,31,33,31,33,30,33,29,42,31,223,31,198,31,211,31,116,31,34,31,108,31,58,31,87,31,87,30,82,31,233,31,164,31,17,31,171,31,128,31,254,31,187,31,43,31,196,31,211,31,185,31,142,31,146,31,46,31,240,31,39,31,5,31,224,31,224,30,51,31,51,30,204,31,251,31,251,30,51,31,96,31,42,31,42,30,249,31,189,31,189,30,140,31,209,31,197,31,23,31,234,31,184,31,37,31,252,31,88,31,77,31,31,31,31,30,85,31,8,31,167,31,168,31,168,30,86,31,180,31,126,31,234,31,156,31,156,30,125,31,125,30,74,31,120,31,40,31,40,30,164,31,95,31,139,31,227,31,212,31,212,30,85,31,83,31,69,31,69,30,69,29,85,31,17,31,166,31,76,31,228,31,228,30,188,31,188,30,188,29,188,28,174,31,41,31,96,31,53,31,170,31,8,31,201,31,31,31,31,30,23,31,157,31,184,31,4,31,208,31,111,31,111,30,111,29,151,31,251,31,66,31,144,31,144,30,125,31,130,31,114,31,189,31,73,31,10,31,169,31,58,31,179,31,135,31,61,31,15,31,1,31,1,30,105,31,176,31,227,31,55,31,72,31,245,31,53,31,51,31,110,31,176,31,7,31,7,30,100,31,201,31,242,31,41,31,154,31,104,31,106,31,106,30,239,31,22,31,223,31,223,30,251,31,231,31,197,31,197,30,82,31,254,31,125,31,125,30,249,31,212,31,86,31,249,31,39,31,76,31,76,30,76,29,125,31,155,31,148,31,72,31,201,31,160,31,160,30,113,31,48,31,109,31,200,31,103,31,247,31,150,31,150,30,21,31,243,31,85,31,160,31,158,31,158,30,22,31,97,31,97,30,29,31,42,31,79,31,205,31,82,31,207,31,26,31,138,31,239,31,227,31,114,31,8,31,202,31,130,31,205,31,205,30,27,31,27,30,27,29,182,31,182,30,128,31,172,31,204,31,8,31,222,31,129,31,202,31,215,31,181,31,181,30,191,31,53,31,220,31,181,31,181,30,104,31,125,31,49,31,89,31,115,31,237,31,22,31,188,31,188,30,71,31,71,30,2,31,155,31,229,31,58,31,150,31,196,31,249,31,115,31,199,31,34,31,34,30,34,29,34,28,34,31,188,31,188,30,112,31,70,31,70,30,55,31,185,31,189,31,191,31,247,31,129,31,36,31,165,31,10,31,243,31,174,31,174,30,132,31,182,31,165,31,154,31,62,31,23,31,106,31,19,31,19,30,158,31,128,31,60,31,85,31,149,31,73,31,108,31,108,30,236,31,235,31,235,30,235,29,105,31,149,31,149,30,87,31,161,31,142,31,68,31,85,31,85,30,50,31,123,31,186,31,247,31,145,31,145,30,155,31,208,31,81,31,15,31,15,30,15,29,44,31,44,30,71,31,48,31,201,31,18,31,45,31,45,30,146,31,69,31,72,31,176,31,195,31,66,31,66,31,154,31,69,31,69,30,172,31,3,31,3,30,3,29,44,31,44,30,211,31,221,31,232,31,232,30,232,29,105,31,99,31,20,31,77,31,57,31,213,31,9,31,9,30,9,29,176,31,127,31,19,31,185,31,143,31,143,30,120,31,218,31,120,31,78,31,223,31,223,30,150,31,113,31,191,31,193,31,166,31,10,31,178,31,178,30,66,31,103,31,17,31,17,30,17,29,198,31,47,31,55,31,43,31,43,30,248,31,83,31,158,31,200,31,200,30,200,29,247,31,247,30,219,31,35,31,206,31,211,31,211,30,219,31,108,31,234,31,26,31,81,31,81,31,199,31,166,31,70,31,158,31,158,30,158,29,159,31,251,31,118,31,192,31,192,30,251,31,166,31,66,31,60,31,106,31,219,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
