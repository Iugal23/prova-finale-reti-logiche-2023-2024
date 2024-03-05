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

constant SCENARIO_LENGTH : integer := 399;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (9,0,155,0,0,0,0,0,183,0,28,0,36,0,103,0,100,0,0,0,250,0,107,0,0,0,204,0,169,0,40,0,78,0,149,0,151,0,147,0,0,0,0,0,187,0,0,0,0,0,16,0,208,0,119,0,164,0,35,0,116,0,73,0,71,0,26,0,0,0,24,0,0,0,184,0,112,0,147,0,0,0,16,0,0,0,217,0,163,0,188,0,29,0,0,0,237,0,114,0,133,0,12,0,215,0,91,0,134,0,126,0,0,0,124,0,211,0,230,0,57,0,212,0,204,0,42,0,39,0,199,0,248,0,57,0,23,0,0,0,29,0,0,0,255,0,103,0,254,0,0,0,75,0,234,0,9,0,219,0,138,0,143,0,45,0,0,0,102,0,106,0,180,0,253,0,0,0,92,0,58,0,0,0,0,0,93,0,98,0,119,0,246,0,0,0,171,0,250,0,0,0,89,0,48,0,0,0,235,0,84,0,100,0,68,0,6,0,121,0,244,0,0,0,0,0,196,0,233,0,209,0,186,0,0,0,21,0,231,0,113,0,188,0,211,0,235,0,191,0,162,0,123,0,78,0,0,0,145,0,164,0,0,0,202,0,12,0,14,0,178,0,165,0,37,0,103,0,225,0,102,0,0,0,0,0,228,0,0,0,0,0,18,0,0,0,246,0,0,0,227,0,0,0,0,0,57,0,214,0,187,0,255,0,153,0,154,0,0,0,0,0,151,0,40,0,187,0,206,0,85,0,19,0,46,0,207,0,62,0,158,0,6,0,46,0,0,0,124,0,171,0,170,0,101,0,191,0,242,0,141,0,68,0,117,0,78,0,0,0,208,0,122,0,0,0,76,0,215,0,33,0,207,0,74,0,0,0,157,0,74,0,159,0,0,0,0,0,25,0,168,0,167,0,9,0,63,0,49,0,197,0,212,0,0,0,214,0,49,0,195,0,104,0,174,0,140,0,8,0,241,0,13,0,182,0,184,0,213,0,166,0,0,0,18,0,232,0,0,0,132,0,187,0,175,0,41,0,244,0,134,0,199,0,99,0,159,0,25,0,250,0,96,0,196,0,89,0,99,0,171,0,161,0,41,0,55,0,176,0,188,0,18,0,210,0,175,0,255,0,112,0,0,0,246,0,0,0,98,0,172,0,116,0,0,0,157,0,172,0,77,0,171,0,80,0,202,0,233,0,221,0,2,0,9,0,0,0,82,0,0,0,194,0,2,0,200,0,164,0,134,0,145,0,0,0,98,0,10,0,78,0,98,0,72,0,41,0,186,0,0,0,0,0,114,0,167,0,49,0,213,0,0,0,181,0,101,0,12,0,0,0,201,0,44,0,223,0,135,0,145,0,150,0,156,0,250,0,0,0,144,0,238,0,219,0,43,0,203,0,203,0,135,0,0,0,0,0,190,0,216,0,0,0,70,0,129,0,58,0,0,0,65,0,188,0,0,0,152,0,0,0,20,0,74,0,0,0,163,0,255,0,213,0,172,0,183,0,0,0,241,0,0,0,202,0,41,0,0,0,222,0,209,0,216,0,0,0,238,0,184,0,0,0,221,0,217,0,0,0,112,0,87,0,157,0,0,0,139,0,0,0,251,0,121,0,126,0,241,0,128,0,59,0,97,0,218,0,115,0,123,0,75,0,143,0,27,0,15,0,14,0,0,0,147,0,236,0,57,0,112,0,81,0,0,0,81,0,54,0,220,0,163,0,0,0,230,0,33,0,125,0,231,0,0,0,0,0,30,0,105,0,143,0,27,0,131,0,246,0,138,0,0,0,0,0,104,0);
signal scenario_full  : scenario_type := (9,31,155,31,155,30,155,29,183,31,28,31,36,31,103,31,100,31,100,30,250,31,107,31,107,30,204,31,169,31,40,31,78,31,149,31,151,31,147,31,147,30,147,29,187,31,187,30,187,29,16,31,208,31,119,31,164,31,35,31,116,31,73,31,71,31,26,31,26,30,24,31,24,30,184,31,112,31,147,31,147,30,16,31,16,30,217,31,163,31,188,31,29,31,29,30,237,31,114,31,133,31,12,31,215,31,91,31,134,31,126,31,126,30,124,31,211,31,230,31,57,31,212,31,204,31,42,31,39,31,199,31,248,31,57,31,23,31,23,30,29,31,29,30,255,31,103,31,254,31,254,30,75,31,234,31,9,31,219,31,138,31,143,31,45,31,45,30,102,31,106,31,180,31,253,31,253,30,92,31,58,31,58,30,58,29,93,31,98,31,119,31,246,31,246,30,171,31,250,31,250,30,89,31,48,31,48,30,235,31,84,31,100,31,68,31,6,31,121,31,244,31,244,30,244,29,196,31,233,31,209,31,186,31,186,30,21,31,231,31,113,31,188,31,211,31,235,31,191,31,162,31,123,31,78,31,78,30,145,31,164,31,164,30,202,31,12,31,14,31,178,31,165,31,37,31,103,31,225,31,102,31,102,30,102,29,228,31,228,30,228,29,18,31,18,30,246,31,246,30,227,31,227,30,227,29,57,31,214,31,187,31,255,31,153,31,154,31,154,30,154,29,151,31,40,31,187,31,206,31,85,31,19,31,46,31,207,31,62,31,158,31,6,31,46,31,46,30,124,31,171,31,170,31,101,31,191,31,242,31,141,31,68,31,117,31,78,31,78,30,208,31,122,31,122,30,76,31,215,31,33,31,207,31,74,31,74,30,157,31,74,31,159,31,159,30,159,29,25,31,168,31,167,31,9,31,63,31,49,31,197,31,212,31,212,30,214,31,49,31,195,31,104,31,174,31,140,31,8,31,241,31,13,31,182,31,184,31,213,31,166,31,166,30,18,31,232,31,232,30,132,31,187,31,175,31,41,31,244,31,134,31,199,31,99,31,159,31,25,31,250,31,96,31,196,31,89,31,99,31,171,31,161,31,41,31,55,31,176,31,188,31,18,31,210,31,175,31,255,31,112,31,112,30,246,31,246,30,98,31,172,31,116,31,116,30,157,31,172,31,77,31,171,31,80,31,202,31,233,31,221,31,2,31,9,31,9,30,82,31,82,30,194,31,2,31,200,31,164,31,134,31,145,31,145,30,98,31,10,31,78,31,98,31,72,31,41,31,186,31,186,30,186,29,114,31,167,31,49,31,213,31,213,30,181,31,101,31,12,31,12,30,201,31,44,31,223,31,135,31,145,31,150,31,156,31,250,31,250,30,144,31,238,31,219,31,43,31,203,31,203,31,135,31,135,30,135,29,190,31,216,31,216,30,70,31,129,31,58,31,58,30,65,31,188,31,188,30,152,31,152,30,20,31,74,31,74,30,163,31,255,31,213,31,172,31,183,31,183,30,241,31,241,30,202,31,41,31,41,30,222,31,209,31,216,31,216,30,238,31,184,31,184,30,221,31,217,31,217,30,112,31,87,31,157,31,157,30,139,31,139,30,251,31,121,31,126,31,241,31,128,31,59,31,97,31,218,31,115,31,123,31,75,31,143,31,27,31,15,31,14,31,14,30,147,31,236,31,57,31,112,31,81,31,81,30,81,31,54,31,220,31,163,31,163,30,230,31,33,31,125,31,231,31,231,30,231,29,30,31,105,31,143,31,27,31,131,31,246,31,138,31,138,30,138,29,104,31);

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
