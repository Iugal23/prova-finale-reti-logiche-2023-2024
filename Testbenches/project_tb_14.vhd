-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 556;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (146,0,208,0,130,0,150,0,151,0,0,0,156,0,128,0,0,0,24,0,38,0,8,0,0,0,0,0,208,0,0,0,60,0,246,0,0,0,174,0,0,0,217,0,160,0,215,0,63,0,65,0,255,0,114,0,241,0,16,0,41,0,100,0,108,0,212,0,222,0,0,0,116,0,35,0,0,0,0,0,112,0,0,0,0,0,242,0,12,0,224,0,220,0,217,0,244,0,130,0,0,0,196,0,204,0,253,0,151,0,0,0,30,0,242,0,82,0,170,0,226,0,55,0,149,0,71,0,76,0,76,0,170,0,152,0,47,0,150,0,52,0,130,0,187,0,12,0,159,0,236,0,250,0,16,0,0,0,62,0,46,0,120,0,0,0,129,0,135,0,0,0,33,0,235,0,0,0,142,0,183,0,0,0,252,0,46,0,225,0,119,0,165,0,239,0,31,0,186,0,122,0,0,0,183,0,17,0,216,0,99,0,28,0,92,0,0,0,0,0,0,0,246,0,61,0,24,0,0,0,134,0,213,0,0,0,92,0,48,0,221,0,170,0,184,0,0,0,222,0,228,0,51,0,0,0,89,0,160,0,178,0,0,0,0,0,14,0,10,0,234,0,216,0,123,0,0,0,0,0,196,0,0,0,118,0,251,0,157,0,207,0,9,0,140,0,174,0,125,0,138,0,113,0,2,0,227,0,103,0,0,0,168,0,234,0,40,0,240,0,93,0,33,0,21,0,106,0,205,0,58,0,209,0,20,0,45,0,60,0,0,0,22,0,178,0,25,0,251,0,5,0,188,0,96,0,199,0,97,0,0,0,0,0,250,0,24,0,183,0,204,0,2,0,251,0,115,0,242,0,216,0,123,0,116,0,0,0,234,0,7,0,19,0,31,0,0,0,0,0,187,0,125,0,0,0,38,0,252,0,176,0,124,0,152,0,102,0,0,0,0,0,175,0,224,0,99,0,31,0,0,0,177,0,146,0,201,0,107,0,200,0,0,0,109,0,140,0,122,0,233,0,187,0,27,0,199,0,117,0,0,0,112,0,83,0,0,0,175,0,201,0,144,0,197,0,112,0,194,0,138,0,84,0,149,0,142,0,68,0,227,0,209,0,0,0,0,0,0,0,0,0,89,0,169,0,0,0,39,0,103,0,0,0,170,0,38,0,39,0,0,0,108,0,11,0,215,0,72,0,0,0,158,0,69,0,183,0,48,0,117,0,156,0,63,0,211,0,249,0,0,0,237,0,17,0,218,0,243,0,0,0,71,0,0,0,253,0,48,0,143,0,25,0,38,0,164,0,199,0,191,0,119,0,171,0,212,0,117,0,6,0,16,0,110,0,182,0,253,0,121,0,0,0,208,0,0,0,0,0,0,0,128,0,199,0,0,0,69,0,234,0,228,0,0,0,0,0,87,0,238,0,10,0,196,0,89,0,148,0,106,0,203,0,0,0,215,0,0,0,0,0,214,0,88,0,0,0,11,0,178,0,157,0,96,0,112,0,54,0,157,0,60,0,23,0,0,0,168,0,24,0,22,0,0,0,0,0,123,0,39,0,188,0,158,0,146,0,177,0,98,0,111,0,221,0,125,0,251,0,168,0,52,0,173,0,0,0,120,0,0,0,81,0,220,0,196,0,81,0,8,0,70,0,14,0,179,0,200,0,24,0,232,0,0,0,155,0,180,0,77,0,202,0,113,0,0,0,0,0,3,0,0,0,197,0,79,0,19,0,254,0,28,0,171,0,91,0,242,0,0,0,0,0,98,0,143,0,150,0,130,0,241,0,0,0,252,0,112,0,211,0,30,0,198,0,38,0,60,0,143,0,163,0,190,0,111,0,25,0,10,0,43,0,0,0,0,0,0,0,181,0,0,0,0,0,233,0,71,0,5,0,190,0,255,0,246,0,55,0,235,0,33,0,73,0,57,0,227,0,47,0,0,0,5,0,78,0,154,0,71,0,0,0,127,0,106,0,136,0,241,0,125,0,47,0,149,0,147,0,193,0,202,0,121,0,22,0,52,0,180,0,183,0,170,0,179,0,189,0,184,0,108,0,43,0,132,0,8,0,180,0,229,0,120,0,12,0,65,0,0,0,65,0,146,0,146,0,20,0,21,0,66,0,52,0,0,0,0,0,0,0,71,0,249,0,71,0,0,0,169,0,0,0,254,0,235,0,5,0,119,0,129,0,185,0,46,0,78,0,76,0,0,0,232,0,82,0,130,0,0,0,119,0,61,0,58,0,239,0,74,0,112,0,247,0,113,0,0,0,0,0,227,0,190,0,0,0,0,0,0,0,222,0,97,0,42,0,151,0,154,0,220,0,0,0,175,0,145,0,82,0,0,0,85,0,0,0,191,0,49,0,67,0,28,0,192,0,0,0,242,0,161,0,164,0,74,0,28,0,0,0,0,0,0,0,0,0,137,0,226,0,191,0,249,0,9,0,120,0,72,0,157,0,0,0,174,0,206,0,55,0,90,0,0,0,31,0,254,0,242,0);
signal scenario_full  : scenario_type := (146,31,208,31,130,31,150,31,151,31,151,30,156,31,128,31,128,30,24,31,38,31,8,31,8,30,8,29,208,31,208,30,60,31,246,31,246,30,174,31,174,30,217,31,160,31,215,31,63,31,65,31,255,31,114,31,241,31,16,31,41,31,100,31,108,31,212,31,222,31,222,30,116,31,35,31,35,30,35,29,112,31,112,30,112,29,242,31,12,31,224,31,220,31,217,31,244,31,130,31,130,30,196,31,204,31,253,31,151,31,151,30,30,31,242,31,82,31,170,31,226,31,55,31,149,31,71,31,76,31,76,31,170,31,152,31,47,31,150,31,52,31,130,31,187,31,12,31,159,31,236,31,250,31,16,31,16,30,62,31,46,31,120,31,120,30,129,31,135,31,135,30,33,31,235,31,235,30,142,31,183,31,183,30,252,31,46,31,225,31,119,31,165,31,239,31,31,31,186,31,122,31,122,30,183,31,17,31,216,31,99,31,28,31,92,31,92,30,92,29,92,28,246,31,61,31,24,31,24,30,134,31,213,31,213,30,92,31,48,31,221,31,170,31,184,31,184,30,222,31,228,31,51,31,51,30,89,31,160,31,178,31,178,30,178,29,14,31,10,31,234,31,216,31,123,31,123,30,123,29,196,31,196,30,118,31,251,31,157,31,207,31,9,31,140,31,174,31,125,31,138,31,113,31,2,31,227,31,103,31,103,30,168,31,234,31,40,31,240,31,93,31,33,31,21,31,106,31,205,31,58,31,209,31,20,31,45,31,60,31,60,30,22,31,178,31,25,31,251,31,5,31,188,31,96,31,199,31,97,31,97,30,97,29,250,31,24,31,183,31,204,31,2,31,251,31,115,31,242,31,216,31,123,31,116,31,116,30,234,31,7,31,19,31,31,31,31,30,31,29,187,31,125,31,125,30,38,31,252,31,176,31,124,31,152,31,102,31,102,30,102,29,175,31,224,31,99,31,31,31,31,30,177,31,146,31,201,31,107,31,200,31,200,30,109,31,140,31,122,31,233,31,187,31,27,31,199,31,117,31,117,30,112,31,83,31,83,30,175,31,201,31,144,31,197,31,112,31,194,31,138,31,84,31,149,31,142,31,68,31,227,31,209,31,209,30,209,29,209,28,209,27,89,31,169,31,169,30,39,31,103,31,103,30,170,31,38,31,39,31,39,30,108,31,11,31,215,31,72,31,72,30,158,31,69,31,183,31,48,31,117,31,156,31,63,31,211,31,249,31,249,30,237,31,17,31,218,31,243,31,243,30,71,31,71,30,253,31,48,31,143,31,25,31,38,31,164,31,199,31,191,31,119,31,171,31,212,31,117,31,6,31,16,31,110,31,182,31,253,31,121,31,121,30,208,31,208,30,208,29,208,28,128,31,199,31,199,30,69,31,234,31,228,31,228,30,228,29,87,31,238,31,10,31,196,31,89,31,148,31,106,31,203,31,203,30,215,31,215,30,215,29,214,31,88,31,88,30,11,31,178,31,157,31,96,31,112,31,54,31,157,31,60,31,23,31,23,30,168,31,24,31,22,31,22,30,22,29,123,31,39,31,188,31,158,31,146,31,177,31,98,31,111,31,221,31,125,31,251,31,168,31,52,31,173,31,173,30,120,31,120,30,81,31,220,31,196,31,81,31,8,31,70,31,14,31,179,31,200,31,24,31,232,31,232,30,155,31,180,31,77,31,202,31,113,31,113,30,113,29,3,31,3,30,197,31,79,31,19,31,254,31,28,31,171,31,91,31,242,31,242,30,242,29,98,31,143,31,150,31,130,31,241,31,241,30,252,31,112,31,211,31,30,31,198,31,38,31,60,31,143,31,163,31,190,31,111,31,25,31,10,31,43,31,43,30,43,29,43,28,181,31,181,30,181,29,233,31,71,31,5,31,190,31,255,31,246,31,55,31,235,31,33,31,73,31,57,31,227,31,47,31,47,30,5,31,78,31,154,31,71,31,71,30,127,31,106,31,136,31,241,31,125,31,47,31,149,31,147,31,193,31,202,31,121,31,22,31,52,31,180,31,183,31,170,31,179,31,189,31,184,31,108,31,43,31,132,31,8,31,180,31,229,31,120,31,12,31,65,31,65,30,65,31,146,31,146,31,20,31,21,31,66,31,52,31,52,30,52,29,52,28,71,31,249,31,71,31,71,30,169,31,169,30,254,31,235,31,5,31,119,31,129,31,185,31,46,31,78,31,76,31,76,30,232,31,82,31,130,31,130,30,119,31,61,31,58,31,239,31,74,31,112,31,247,31,113,31,113,30,113,29,227,31,190,31,190,30,190,29,190,28,222,31,97,31,42,31,151,31,154,31,220,31,220,30,175,31,145,31,82,31,82,30,85,31,85,30,191,31,49,31,67,31,28,31,192,31,192,30,242,31,161,31,164,31,74,31,28,31,28,30,28,29,28,28,28,27,137,31,226,31,191,31,249,31,9,31,120,31,72,31,157,31,157,30,174,31,206,31,55,31,90,31,90,30,31,31,254,31,242,31);

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
