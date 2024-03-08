-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_203 is
end project_tb_203;

architecture project_tb_arch_203 of project_tb_203 is
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

constant SCENARIO_LENGTH : integer := 557;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (114,0,151,0,0,0,126,0,236,0,0,0,90,0,0,0,58,0,159,0,196,0,113,0,0,0,226,0,0,0,126,0,242,0,170,0,90,0,157,0,0,0,85,0,0,0,10,0,36,0,0,0,121,0,43,0,251,0,207,0,200,0,19,0,166,0,29,0,0,0,157,0,155,0,215,0,0,0,192,0,74,0,31,0,55,0,112,0,108,0,0,0,228,0,62,0,233,0,222,0,23,0,135,0,220,0,152,0,18,0,83,0,0,0,0,0,2,0,84,0,46,0,0,0,197,0,120,0,221,0,88,0,51,0,36,0,170,0,217,0,202,0,48,0,0,0,0,0,22,0,89,0,91,0,0,0,0,0,0,0,74,0,83,0,0,0,23,0,97,0,109,0,0,0,4,0,253,0,132,0,141,0,13,0,0,0,163,0,149,0,72,0,43,0,212,0,0,0,142,0,200,0,101,0,0,0,111,0,105,0,81,0,0,0,75,0,134,0,126,0,111,0,0,0,0,0,59,0,36,0,38,0,0,0,27,0,0,0,98,0,78,0,25,0,157,0,142,0,230,0,0,0,0,0,159,0,239,0,32,0,33,0,123,0,22,0,36,0,196,0,227,0,11,0,29,0,237,0,31,0,61,0,197,0,57,0,227,0,104,0,97,0,77,0,153,0,51,0,222,0,205,0,149,0,24,0,0,0,0,0,0,0,30,0,250,0,122,0,47,0,138,0,196,0,57,0,221,0,70,0,0,0,0,0,187,0,242,0,44,0,0,0,146,0,55,0,215,0,152,0,0,0,227,0,119,0,168,0,37,0,108,0,146,0,48,0,221,0,2,0,52,0,0,0,192,0,137,0,14,0,36,0,159,0,109,0,221,0,0,0,178,0,242,0,83,0,232,0,0,0,239,0,208,0,107,0,209,0,108,0,221,0,21,0,176,0,102,0,133,0,0,0,254,0,148,0,68,0,128,0,204,0,22,0,246,0,241,0,43,0,22,0,0,0,130,0,157,0,217,0,213,0,53,0,8,0,170,0,233,0,3,0,167,0,0,0,172,0,103,0,0,0,101,0,92,0,124,0,34,0,26,0,66,0,191,0,165,0,116,0,52,0,128,0,11,0,159,0,92,0,42,0,172,0,0,0,222,0,205,0,59,0,201,0,0,0,215,0,59,0,10,0,213,0,0,0,169,0,105,0,98,0,15,0,0,0,205,0,158,0,57,0,4,0,242,0,30,0,129,0,170,0,0,0,237,0,120,0,19,0,176,0,119,0,35,0,166,0,0,0,14,0,90,0,53,0,218,0,86,0,210,0,127,0,77,0,57,0,0,0,44,0,251,0,0,0,0,0,5,0,82,0,45,0,89,0,0,0,233,0,34,0,86,0,0,0,69,0,167,0,72,0,227,0,95,0,196,0,0,0,142,0,0,0,213,0,0,0,94,0,81,0,160,0,175,0,134,0,147,0,119,0,13,0,83,0,129,0,107,0,0,0,250,0,151,0,225,0,0,0,210,0,170,0,0,0,94,0,179,0,0,0,217,0,25,0,200,0,212,0,122,0,0,0,187,0,175,0,42,0,94,0,22,0,0,0,180,0,8,0,135,0,214,0,0,0,105,0,138,0,93,0,247,0,28,0,198,0,118,0,235,0,221,0,0,0,0,0,217,0,188,0,248,0,160,0,0,0,41,0,37,0,216,0,96,0,158,0,221,0,88,0,21,0,131,0,0,0,107,0,28,0,114,0,99,0,120,0,85,0,0,0,176,0,5,0,186,0,44,0,0,0,2,0,0,0,151,0,183,0,21,0,0,0,88,0,25,0,0,0,0,0,91,0,0,0,121,0,64,0,139,0,0,0,0,0,76,0,207,0,250,0,123,0,0,0,214,0,8,0,195,0,240,0,73,0,0,0,254,0,85,0,62,0,133,0,112,0,158,0,156,0,0,0,83,0,43,0,64,0,0,0,0,0,39,0,197,0,192,0,171,0,44,0,153,0,63,0,131,0,118,0,228,0,129,0,0,0,231,0,20,0,164,0,0,0,214,0,249,0,85,0,0,0,183,0,0,0,239,0,252,0,141,0,0,0,0,0,0,0,0,0,0,0,169,0,249,0,0,0,120,0,224,0,246,0,201,0,122,0,189,0,93,0,199,0,0,0,0,0,0,0,111,0,46,0,118,0,116,0,139,0,190,0,144,0,0,0,205,0,0,0,37,0,225,0,0,0,201,0,255,0,103,0,143,0,151,0,61,0,239,0,189,0,153,0,0,0,134,0,169,0,122,0,80,0,18,0,110,0,29,0,63,0,87,0,34,0,195,0,130,0,176,0,0,0,0,0,69,0,0,0,0,0,91,0,4,0,231,0,205,0,0,0,214,0,0,0,218,0,0,0,229,0,97,0,201,0,0,0,182,0,0,0,177,0,206,0,114,0,251,0,17,0,0,0,10,0,124,0,113,0,248,0,37,0,218,0,0,0,115,0,0,0,247,0,0,0,42,0,64,0,200,0);
signal scenario_full  : scenario_type := (114,31,151,31,151,30,126,31,236,31,236,30,90,31,90,30,58,31,159,31,196,31,113,31,113,30,226,31,226,30,126,31,242,31,170,31,90,31,157,31,157,30,85,31,85,30,10,31,36,31,36,30,121,31,43,31,251,31,207,31,200,31,19,31,166,31,29,31,29,30,157,31,155,31,215,31,215,30,192,31,74,31,31,31,55,31,112,31,108,31,108,30,228,31,62,31,233,31,222,31,23,31,135,31,220,31,152,31,18,31,83,31,83,30,83,29,2,31,84,31,46,31,46,30,197,31,120,31,221,31,88,31,51,31,36,31,170,31,217,31,202,31,48,31,48,30,48,29,22,31,89,31,91,31,91,30,91,29,91,28,74,31,83,31,83,30,23,31,97,31,109,31,109,30,4,31,253,31,132,31,141,31,13,31,13,30,163,31,149,31,72,31,43,31,212,31,212,30,142,31,200,31,101,31,101,30,111,31,105,31,81,31,81,30,75,31,134,31,126,31,111,31,111,30,111,29,59,31,36,31,38,31,38,30,27,31,27,30,98,31,78,31,25,31,157,31,142,31,230,31,230,30,230,29,159,31,239,31,32,31,33,31,123,31,22,31,36,31,196,31,227,31,11,31,29,31,237,31,31,31,61,31,197,31,57,31,227,31,104,31,97,31,77,31,153,31,51,31,222,31,205,31,149,31,24,31,24,30,24,29,24,28,30,31,250,31,122,31,47,31,138,31,196,31,57,31,221,31,70,31,70,30,70,29,187,31,242,31,44,31,44,30,146,31,55,31,215,31,152,31,152,30,227,31,119,31,168,31,37,31,108,31,146,31,48,31,221,31,2,31,52,31,52,30,192,31,137,31,14,31,36,31,159,31,109,31,221,31,221,30,178,31,242,31,83,31,232,31,232,30,239,31,208,31,107,31,209,31,108,31,221,31,21,31,176,31,102,31,133,31,133,30,254,31,148,31,68,31,128,31,204,31,22,31,246,31,241,31,43,31,22,31,22,30,130,31,157,31,217,31,213,31,53,31,8,31,170,31,233,31,3,31,167,31,167,30,172,31,103,31,103,30,101,31,92,31,124,31,34,31,26,31,66,31,191,31,165,31,116,31,52,31,128,31,11,31,159,31,92,31,42,31,172,31,172,30,222,31,205,31,59,31,201,31,201,30,215,31,59,31,10,31,213,31,213,30,169,31,105,31,98,31,15,31,15,30,205,31,158,31,57,31,4,31,242,31,30,31,129,31,170,31,170,30,237,31,120,31,19,31,176,31,119,31,35,31,166,31,166,30,14,31,90,31,53,31,218,31,86,31,210,31,127,31,77,31,57,31,57,30,44,31,251,31,251,30,251,29,5,31,82,31,45,31,89,31,89,30,233,31,34,31,86,31,86,30,69,31,167,31,72,31,227,31,95,31,196,31,196,30,142,31,142,30,213,31,213,30,94,31,81,31,160,31,175,31,134,31,147,31,119,31,13,31,83,31,129,31,107,31,107,30,250,31,151,31,225,31,225,30,210,31,170,31,170,30,94,31,179,31,179,30,217,31,25,31,200,31,212,31,122,31,122,30,187,31,175,31,42,31,94,31,22,31,22,30,180,31,8,31,135,31,214,31,214,30,105,31,138,31,93,31,247,31,28,31,198,31,118,31,235,31,221,31,221,30,221,29,217,31,188,31,248,31,160,31,160,30,41,31,37,31,216,31,96,31,158,31,221,31,88,31,21,31,131,31,131,30,107,31,28,31,114,31,99,31,120,31,85,31,85,30,176,31,5,31,186,31,44,31,44,30,2,31,2,30,151,31,183,31,21,31,21,30,88,31,25,31,25,30,25,29,91,31,91,30,121,31,64,31,139,31,139,30,139,29,76,31,207,31,250,31,123,31,123,30,214,31,8,31,195,31,240,31,73,31,73,30,254,31,85,31,62,31,133,31,112,31,158,31,156,31,156,30,83,31,43,31,64,31,64,30,64,29,39,31,197,31,192,31,171,31,44,31,153,31,63,31,131,31,118,31,228,31,129,31,129,30,231,31,20,31,164,31,164,30,214,31,249,31,85,31,85,30,183,31,183,30,239,31,252,31,141,31,141,30,141,29,141,28,141,27,141,26,169,31,249,31,249,30,120,31,224,31,246,31,201,31,122,31,189,31,93,31,199,31,199,30,199,29,199,28,111,31,46,31,118,31,116,31,139,31,190,31,144,31,144,30,205,31,205,30,37,31,225,31,225,30,201,31,255,31,103,31,143,31,151,31,61,31,239,31,189,31,153,31,153,30,134,31,169,31,122,31,80,31,18,31,110,31,29,31,63,31,87,31,34,31,195,31,130,31,176,31,176,30,176,29,69,31,69,30,69,29,91,31,4,31,231,31,205,31,205,30,214,31,214,30,218,31,218,30,229,31,97,31,201,31,201,30,182,31,182,30,177,31,206,31,114,31,251,31,17,31,17,30,10,31,124,31,113,31,248,31,37,31,218,31,218,30,115,31,115,30,247,31,247,30,42,31,64,31,200,31);

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
