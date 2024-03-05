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

constant SCENARIO_LENGTH : integer := 474;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (247,0,231,0,228,0,253,0,213,0,180,0,0,0,75,0,114,0,150,0,130,0,228,0,126,0,104,0,231,0,11,0,217,0,0,0,247,0,229,0,0,0,0,0,24,0,0,0,8,0,111,0,0,0,0,0,142,0,0,0,54,0,122,0,0,0,190,0,63,0,0,0,29,0,148,0,177,0,17,0,71,0,119,0,0,0,248,0,190,0,45,0,200,0,36,0,13,0,0,0,179,0,159,0,0,0,110,0,0,0,168,0,176,0,193,0,0,0,82,0,167,0,0,0,92,0,158,0,41,0,56,0,102,0,53,0,3,0,210,0,189,0,0,0,30,0,150,0,19,0,124,0,242,0,215,0,232,0,228,0,83,0,23,0,205,0,234,0,234,0,237,0,234,0,250,0,250,0,0,0,196,0,209,0,0,0,74,0,67,0,0,0,228,0,21,0,0,0,231,0,94,0,150,0,161,0,94,0,54,0,0,0,59,0,47,0,0,0,0,0,226,0,0,0,0,0,126,0,67,0,210,0,42,0,139,0,179,0,113,0,2,0,103,0,54,0,191,0,104,0,0,0,0,0,245,0,100,0,214,0,10,0,0,0,198,0,44,0,0,0,51,0,94,0,243,0,42,0,15,0,126,0,12,0,120,0,187,0,0,0,69,0,229,0,214,0,115,0,0,0,83,0,0,0,186,0,240,0,0,0,0,0,163,0,229,0,83,0,221,0,30,0,59,0,196,0,207,0,230,0,12,0,0,0,29,0,0,0,124,0,44,0,74,0,172,0,135,0,0,0,169,0,28,0,184,0,28,0,103,0,0,0,128,0,11,0,0,0,66,0,0,0,125,0,0,0,248,0,14,0,0,0,167,0,228,0,200,0,97,0,78,0,245,0,13,0,36,0,0,0,221,0,226,0,89,0,9,0,254,0,241,0,24,0,218,0,246,0,156,0,180,0,31,0,170,0,121,0,0,0,20,0,0,0,0,0,101,0,0,0,217,0,229,0,177,0,4,0,5,0,65,0,129,0,222,0,121,0,142,0,237,0,97,0,3,0,64,0,38,0,0,0,58,0,200,0,196,0,135,0,40,0,0,0,85,0,46,0,13,0,64,0,59,0,0,0,137,0,136,0,56,0,24,0,0,0,201,0,104,0,0,0,60,0,172,0,58,0,143,0,0,0,5,0,213,0,223,0,210,0,0,0,88,0,0,0,135,0,159,0,149,0,198,0,181,0,79,0,100,0,141,0,121,0,0,0,178,0,27,0,26,0,119,0,155,0,1,0,0,0,0,0,147,0,208,0,217,0,0,0,75,0,173,0,45,0,114,0,0,0,133,0,148,0,147,0,0,0,0,0,45,0,110,0,251,0,0,0,6,0,0,0,164,0,112,0,48,0,0,0,0,0,25,0,21,0,43,0,155,0,45,0,0,0,75,0,156,0,29,0,18,0,0,0,83,0,69,0,12,0,195,0,225,0,28,0,185,0,202,0,0,0,0,0,44,0,237,0,59,0,233,0,197,0,166,0,201,0,0,0,165,0,63,0,94,0,46,0,243,0,102,0,160,0,27,0,0,0,175,0,179,0,20,0,132,0,76,0,94,0,193,0,46,0,123,0,79,0,222,0,8,0,232,0,11,0,86,0,39,0,0,0,31,0,45,0,132,0,57,0,28,0,12,0,69,0,127,0,0,0,189,0,181,0,141,0,197,0,100,0,12,0,168,0,7,0,0,0,12,0,250,0,225,0,169,0,88,0,217,0,174,0,50,0,178,0,63,0,16,0,201,0,0,0,0,0,235,0,61,0,0,0,157,0,150,0,116,0,12,0,24,0,118,0,179,0,215,0,187,0,179,0,0,0,126,0,71,0,0,0,41,0,106,0,111,0,92,0,36,0,149,0,46,0,135,0,36,0,24,0,152,0,0,0,0,0,81,0,0,0,52,0,80,0,98,0,161,0,189,0,179,0,43,0,216,0,0,0,0,0,186,0,250,0,0,0,81,0,238,0,102,0,0,0,0,0,217,0,7,0,158,0,76,0,0,0,102,0,0,0,0,0,238,0,0,0,124,0,248,0,0,0,188,0,146,0,117,0,250,0,0,0,0,0,0,0,124,0,0,0,205,0,0,0,125,0,127,0);
signal scenario_full  : scenario_type := (247,31,231,31,228,31,253,31,213,31,180,31,180,30,75,31,114,31,150,31,130,31,228,31,126,31,104,31,231,31,11,31,217,31,217,30,247,31,229,31,229,30,229,29,24,31,24,30,8,31,111,31,111,30,111,29,142,31,142,30,54,31,122,31,122,30,190,31,63,31,63,30,29,31,148,31,177,31,17,31,71,31,119,31,119,30,248,31,190,31,45,31,200,31,36,31,13,31,13,30,179,31,159,31,159,30,110,31,110,30,168,31,176,31,193,31,193,30,82,31,167,31,167,30,92,31,158,31,41,31,56,31,102,31,53,31,3,31,210,31,189,31,189,30,30,31,150,31,19,31,124,31,242,31,215,31,232,31,228,31,83,31,23,31,205,31,234,31,234,31,237,31,234,31,250,31,250,31,250,30,196,31,209,31,209,30,74,31,67,31,67,30,228,31,21,31,21,30,231,31,94,31,150,31,161,31,94,31,54,31,54,30,59,31,47,31,47,30,47,29,226,31,226,30,226,29,126,31,67,31,210,31,42,31,139,31,179,31,113,31,2,31,103,31,54,31,191,31,104,31,104,30,104,29,245,31,100,31,214,31,10,31,10,30,198,31,44,31,44,30,51,31,94,31,243,31,42,31,15,31,126,31,12,31,120,31,187,31,187,30,69,31,229,31,214,31,115,31,115,30,83,31,83,30,186,31,240,31,240,30,240,29,163,31,229,31,83,31,221,31,30,31,59,31,196,31,207,31,230,31,12,31,12,30,29,31,29,30,124,31,44,31,74,31,172,31,135,31,135,30,169,31,28,31,184,31,28,31,103,31,103,30,128,31,11,31,11,30,66,31,66,30,125,31,125,30,248,31,14,31,14,30,167,31,228,31,200,31,97,31,78,31,245,31,13,31,36,31,36,30,221,31,226,31,89,31,9,31,254,31,241,31,24,31,218,31,246,31,156,31,180,31,31,31,170,31,121,31,121,30,20,31,20,30,20,29,101,31,101,30,217,31,229,31,177,31,4,31,5,31,65,31,129,31,222,31,121,31,142,31,237,31,97,31,3,31,64,31,38,31,38,30,58,31,200,31,196,31,135,31,40,31,40,30,85,31,46,31,13,31,64,31,59,31,59,30,137,31,136,31,56,31,24,31,24,30,201,31,104,31,104,30,60,31,172,31,58,31,143,31,143,30,5,31,213,31,223,31,210,31,210,30,88,31,88,30,135,31,159,31,149,31,198,31,181,31,79,31,100,31,141,31,121,31,121,30,178,31,27,31,26,31,119,31,155,31,1,31,1,30,1,29,147,31,208,31,217,31,217,30,75,31,173,31,45,31,114,31,114,30,133,31,148,31,147,31,147,30,147,29,45,31,110,31,251,31,251,30,6,31,6,30,164,31,112,31,48,31,48,30,48,29,25,31,21,31,43,31,155,31,45,31,45,30,75,31,156,31,29,31,18,31,18,30,83,31,69,31,12,31,195,31,225,31,28,31,185,31,202,31,202,30,202,29,44,31,237,31,59,31,233,31,197,31,166,31,201,31,201,30,165,31,63,31,94,31,46,31,243,31,102,31,160,31,27,31,27,30,175,31,179,31,20,31,132,31,76,31,94,31,193,31,46,31,123,31,79,31,222,31,8,31,232,31,11,31,86,31,39,31,39,30,31,31,45,31,132,31,57,31,28,31,12,31,69,31,127,31,127,30,189,31,181,31,141,31,197,31,100,31,12,31,168,31,7,31,7,30,12,31,250,31,225,31,169,31,88,31,217,31,174,31,50,31,178,31,63,31,16,31,201,31,201,30,201,29,235,31,61,31,61,30,157,31,150,31,116,31,12,31,24,31,118,31,179,31,215,31,187,31,179,31,179,30,126,31,71,31,71,30,41,31,106,31,111,31,92,31,36,31,149,31,46,31,135,31,36,31,24,31,152,31,152,30,152,29,81,31,81,30,52,31,80,31,98,31,161,31,189,31,179,31,43,31,216,31,216,30,216,29,186,31,250,31,250,30,81,31,238,31,102,31,102,30,102,29,217,31,7,31,158,31,76,31,76,30,102,31,102,30,102,29,238,31,238,30,124,31,248,31,248,30,188,31,146,31,117,31,250,31,250,30,250,29,250,28,124,31,124,30,205,31,205,30,125,31,127,31);

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
