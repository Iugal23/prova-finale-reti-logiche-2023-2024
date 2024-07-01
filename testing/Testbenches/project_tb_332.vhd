-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_332 is
end project_tb_332;

architecture project_tb_arch_332 of project_tb_332 is
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

constant SCENARIO_LENGTH : integer := 599;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (157,0,128,0,3,0,0,0,128,0,251,0,243,0,111,0,0,0,212,0,101,0,83,0,78,0,0,0,39,0,0,0,197,0,224,0,99,0,239,0,111,0,239,0,48,0,210,0,0,0,0,0,0,0,61,0,135,0,0,0,213,0,238,0,43,0,6,0,204,0,164,0,236,0,180,0,47,0,0,0,193,0,229,0,94,0,247,0,0,0,222,0,50,0,0,0,195,0,80,0,224,0,96,0,89,0,26,0,55,0,21,0,111,0,202,0,12,0,0,0,120,0,249,0,135,0,54,0,250,0,36,0,52,0,249,0,0,0,2,0,45,0,254,0,0,0,17,0,2,0,109,0,95,0,207,0,234,0,197,0,0,0,233,0,0,0,226,0,0,0,113,0,232,0,0,0,22,0,83,0,106,0,0,0,13,0,58,0,243,0,33,0,211,0,0,0,0,0,0,0,247,0,139,0,226,0,81,0,249,0,158,0,134,0,241,0,165,0,56,0,0,0,158,0,211,0,146,0,196,0,253,0,9,0,71,0,151,0,0,0,2,0,143,0,69,0,0,0,128,0,213,0,178,0,166,0,69,0,167,0,113,0,130,0,12,0,211,0,144,0,244,0,0,0,0,0,99,0,110,0,43,0,28,0,130,0,0,0,95,0,235,0,199,0,171,0,25,0,97,0,77,0,165,0,0,0,253,0,202,0,15,0,72,0,171,0,86,0,114,0,185,0,121,0,0,0,192,0,3,0,0,0,66,0,240,0,0,0,202,0,147,0,0,0,80,0,0,0,106,0,228,0,110,0,55,0,128,0,123,0,180,0,71,0,0,0,35,0,222,0,54,0,5,0,50,0,193,0,233,0,0,0,142,0,109,0,132,0,253,0,211,0,0,0,0,0,98,0,0,0,187,0,39,0,0,0,210,0,15,0,0,0,236,0,216,0,44,0,124,0,47,0,182,0,68,0,60,0,203,0,37,0,84,0,247,0,106,0,0,0,170,0,0,0,43,0,117,0,0,0,168,0,83,0,106,0,0,0,45,0,248,0,171,0,0,0,77,0,59,0,0,0,0,0,63,0,185,0,0,0,1,0,118,0,144,0,168,0,236,0,96,0,157,0,202,0,39,0,37,0,0,0,0,0,6,0,165,0,0,0,25,0,28,0,150,0,251,0,0,0,0,0,0,0,217,0,140,0,165,0,152,0,42,0,90,0,0,0,0,0,0,0,164,0,52,0,245,0,208,0,157,0,0,0,0,0,11,0,0,0,0,0,226,0,181,0,183,0,0,0,92,0,239,0,105,0,170,0,45,0,61,0,208,0,224,0,230,0,0,0,162,0,66,0,2,0,102,0,113,0,95,0,0,0,128,0,40,0,207,0,112,0,38,0,121,0,24,0,0,0,142,0,239,0,196,0,67,0,0,0,13,0,0,0,9,0,64,0,242,0,106,0,0,0,0,0,0,0,0,0,210,0,226,0,128,0,107,0,5,0,0,0,102,0,118,0,96,0,0,0,193,0,28,0,0,0,190,0,100,0,222,0,203,0,88,0,82,0,238,0,25,0,57,0,0,0,0,0,33,0,142,0,0,0,33,0,0,0,168,0,239,0,13,0,98,0,18,0,0,0,251,0,0,0,231,0,19,0,0,0,198,0,34,0,80,0,178,0,233,0,0,0,111,0,135,0,69,0,158,0,65,0,243,0,0,0,208,0,0,0,0,0,0,0,33,0,0,0,140,0,218,0,65,0,65,0,174,0,99,0,53,0,44,0,0,0,211,0,33,0,229,0,187,0,82,0,0,0,0,0,0,0,208,0,64,0,38,0,180,0,0,0,0,0,7,0,151,0,185,0,88,0,117,0,147,0,0,0,55,0,0,0,8,0,200,0,0,0,0,0,83,0,119,0,61,0,0,0,190,0,201,0,0,0,190,0,44,0,84,0,177,0,244,0,134,0,202,0,117,0,119,0,184,0,83,0,6,0,163,0,90,0,3,0,30,0,178,0,239,0,0,0,0,0,49,0,122,0,0,0,30,0,113,0,156,0,190,0,210,0,100,0,205,0,0,0,211,0,144,0,41,0,51,0,201,0,230,0,17,0,105,0,224,0,0,0,120,0,0,0,100,0,81,0,155,0,59,0,211,0,21,0,108,0,228,0,227,0,171,0,54,0,159,0,142,0,75,0,0,0,194,0,52,0,212,0,0,0,7,0,79,0,240,0,247,0,217,0,239,0,10,0,160,0,0,0,0,0,0,0,0,0,90,0,0,0,99,0,55,0,125,0,88,0,35,0,71,0,0,0,164,0,0,0,38,0,0,0,167,0,63,0,0,0,0,0,72,0,216,0,177,0,228,0,39,0,188,0,0,0,165,0,0,0,0,0,0,0,167,0,128,0,0,0,241,0,145,0,229,0,245,0,15,0,0,0,0,0,217,0,167,0,158,0,223,0,0,0,251,0,66,0,214,0,218,0,0,0,74,0,96,0,202,0,108,0,148,0,0,0,137,0,78,0,57,0,25,0,204,0,215,0,249,0,0,0,168,0,0,0,0,0,38,0,115,0,0,0,145,0,138,0,117,0,213,0,34,0,103,0,147,0,0,0,65,0,22,0,153,0,120,0,104,0,236,0,0,0,212,0,79,0,0,0,62,0,124,0,40,0,0,0,84,0,77,0,189,0,48,0,54,0,254,0,0,0,62,0);
signal scenario_full  : scenario_type := (157,31,128,31,3,31,3,30,128,31,251,31,243,31,111,31,111,30,212,31,101,31,83,31,78,31,78,30,39,31,39,30,197,31,224,31,99,31,239,31,111,31,239,31,48,31,210,31,210,30,210,29,210,28,61,31,135,31,135,30,213,31,238,31,43,31,6,31,204,31,164,31,236,31,180,31,47,31,47,30,193,31,229,31,94,31,247,31,247,30,222,31,50,31,50,30,195,31,80,31,224,31,96,31,89,31,26,31,55,31,21,31,111,31,202,31,12,31,12,30,120,31,249,31,135,31,54,31,250,31,36,31,52,31,249,31,249,30,2,31,45,31,254,31,254,30,17,31,2,31,109,31,95,31,207,31,234,31,197,31,197,30,233,31,233,30,226,31,226,30,113,31,232,31,232,30,22,31,83,31,106,31,106,30,13,31,58,31,243,31,33,31,211,31,211,30,211,29,211,28,247,31,139,31,226,31,81,31,249,31,158,31,134,31,241,31,165,31,56,31,56,30,158,31,211,31,146,31,196,31,253,31,9,31,71,31,151,31,151,30,2,31,143,31,69,31,69,30,128,31,213,31,178,31,166,31,69,31,167,31,113,31,130,31,12,31,211,31,144,31,244,31,244,30,244,29,99,31,110,31,43,31,28,31,130,31,130,30,95,31,235,31,199,31,171,31,25,31,97,31,77,31,165,31,165,30,253,31,202,31,15,31,72,31,171,31,86,31,114,31,185,31,121,31,121,30,192,31,3,31,3,30,66,31,240,31,240,30,202,31,147,31,147,30,80,31,80,30,106,31,228,31,110,31,55,31,128,31,123,31,180,31,71,31,71,30,35,31,222,31,54,31,5,31,50,31,193,31,233,31,233,30,142,31,109,31,132,31,253,31,211,31,211,30,211,29,98,31,98,30,187,31,39,31,39,30,210,31,15,31,15,30,236,31,216,31,44,31,124,31,47,31,182,31,68,31,60,31,203,31,37,31,84,31,247,31,106,31,106,30,170,31,170,30,43,31,117,31,117,30,168,31,83,31,106,31,106,30,45,31,248,31,171,31,171,30,77,31,59,31,59,30,59,29,63,31,185,31,185,30,1,31,118,31,144,31,168,31,236,31,96,31,157,31,202,31,39,31,37,31,37,30,37,29,6,31,165,31,165,30,25,31,28,31,150,31,251,31,251,30,251,29,251,28,217,31,140,31,165,31,152,31,42,31,90,31,90,30,90,29,90,28,164,31,52,31,245,31,208,31,157,31,157,30,157,29,11,31,11,30,11,29,226,31,181,31,183,31,183,30,92,31,239,31,105,31,170,31,45,31,61,31,208,31,224,31,230,31,230,30,162,31,66,31,2,31,102,31,113,31,95,31,95,30,128,31,40,31,207,31,112,31,38,31,121,31,24,31,24,30,142,31,239,31,196,31,67,31,67,30,13,31,13,30,9,31,64,31,242,31,106,31,106,30,106,29,106,28,106,27,210,31,226,31,128,31,107,31,5,31,5,30,102,31,118,31,96,31,96,30,193,31,28,31,28,30,190,31,100,31,222,31,203,31,88,31,82,31,238,31,25,31,57,31,57,30,57,29,33,31,142,31,142,30,33,31,33,30,168,31,239,31,13,31,98,31,18,31,18,30,251,31,251,30,231,31,19,31,19,30,198,31,34,31,80,31,178,31,233,31,233,30,111,31,135,31,69,31,158,31,65,31,243,31,243,30,208,31,208,30,208,29,208,28,33,31,33,30,140,31,218,31,65,31,65,31,174,31,99,31,53,31,44,31,44,30,211,31,33,31,229,31,187,31,82,31,82,30,82,29,82,28,208,31,64,31,38,31,180,31,180,30,180,29,7,31,151,31,185,31,88,31,117,31,147,31,147,30,55,31,55,30,8,31,200,31,200,30,200,29,83,31,119,31,61,31,61,30,190,31,201,31,201,30,190,31,44,31,84,31,177,31,244,31,134,31,202,31,117,31,119,31,184,31,83,31,6,31,163,31,90,31,3,31,30,31,178,31,239,31,239,30,239,29,49,31,122,31,122,30,30,31,113,31,156,31,190,31,210,31,100,31,205,31,205,30,211,31,144,31,41,31,51,31,201,31,230,31,17,31,105,31,224,31,224,30,120,31,120,30,100,31,81,31,155,31,59,31,211,31,21,31,108,31,228,31,227,31,171,31,54,31,159,31,142,31,75,31,75,30,194,31,52,31,212,31,212,30,7,31,79,31,240,31,247,31,217,31,239,31,10,31,160,31,160,30,160,29,160,28,160,27,90,31,90,30,99,31,55,31,125,31,88,31,35,31,71,31,71,30,164,31,164,30,38,31,38,30,167,31,63,31,63,30,63,29,72,31,216,31,177,31,228,31,39,31,188,31,188,30,165,31,165,30,165,29,165,28,167,31,128,31,128,30,241,31,145,31,229,31,245,31,15,31,15,30,15,29,217,31,167,31,158,31,223,31,223,30,251,31,66,31,214,31,218,31,218,30,74,31,96,31,202,31,108,31,148,31,148,30,137,31,78,31,57,31,25,31,204,31,215,31,249,31,249,30,168,31,168,30,168,29,38,31,115,31,115,30,145,31,138,31,117,31,213,31,34,31,103,31,147,31,147,30,65,31,22,31,153,31,120,31,104,31,236,31,236,30,212,31,79,31,79,30,62,31,124,31,40,31,40,30,84,31,77,31,189,31,48,31,54,31,254,31,254,30,62,31);

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
