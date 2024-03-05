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

constant SCENARIO_LENGTH : integer := 424;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,64,0,111,0,148,0,61,0,76,0,190,0,39,0,135,0,249,0,127,0,32,0,100,0,66,0,70,0,233,0,224,0,96,0,51,0,63,0,110,0,14,0,0,0,146,0,212,0,0,0,194,0,0,0,164,0,188,0,41,0,137,0,0,0,234,0,0,0,48,0,217,0,168,0,213,0,103,0,42,0,0,0,253,0,68,0,247,0,6,0,224,0,241,0,126,0,0,0,39,0,113,0,206,0,98,0,0,0,211,0,171,0,126,0,223,0,0,0,0,0,53,0,206,0,117,0,0,0,161,0,33,0,0,0,178,0,50,0,219,0,0,0,219,0,60,0,129,0,146,0,0,0,107,0,135,0,170,0,185,0,205,0,43,0,0,0,12,0,57,0,0,0,0,0,161,0,0,0,0,0,71,0,0,0,75,0,188,0,0,0,16,0,32,0,243,0,99,0,113,0,35,0,51,0,63,0,98,0,64,0,120,0,7,0,98,0,61,0,183,0,230,0,83,0,0,0,0,0,156,0,0,0,182,0,166,0,170,0,66,0,72,0,248,0,0,0,56,0,0,0,253,0,166,0,195,0,193,0,248,0,196,0,26,0,73,0,114,0,107,0,205,0,20,0,59,0,210,0,210,0,0,0,195,0,103,0,235,0,71,0,152,0,31,0,194,0,120,0,243,0,101,0,92,0,18,0,0,0,244,0,142,0,87,0,26,0,72,0,0,0,220,0,122,0,0,0,117,0,0,0,211,0,80,0,191,0,7,0,182,0,0,0,189,0,14,0,105,0,183,0,67,0,168,0,44,0,0,0,15,0,182,0,33,0,0,0,166,0,0,0,197,0,4,0,201,0,207,0,48,0,75,0,190,0,192,0,76,0,161,0,105,0,184,0,0,0,37,0,57,0,0,0,18,0,0,0,233,0,32,0,0,0,234,0,175,0,0,0,50,0,0,0,31,0,56,0,232,0,132,0,0,0,24,0,176,0,0,0,84,0,73,0,29,0,4,0,0,0,143,0,0,0,254,0,81,0,70,0,216,0,31,0,231,0,180,0,0,0,167,0,0,0,237,0,159,0,81,0,111,0,23,0,249,0,122,0,201,0,230,0,51,0,234,0,0,0,143,0,169,0,0,0,255,0,168,0,69,0,0,0,147,0,156,0,188,0,0,0,183,0,0,0,0,0,109,0,40,0,47,0,0,0,191,0,66,0,254,0,251,0,160,0,6,0,14,0,187,0,46,0,10,0,26,0,234,0,206,0,62,0,168,0,238,0,0,0,0,0,9,0,234,0,119,0,200,0,110,0,187,0,0,0,0,0,0,0,48,0,126,0,218,0,251,0,203,0,94,0,181,0,28,0,0,0,114,0,138,0,74,0,48,0,194,0,0,0,236,0,0,0,176,0,0,0,14,0,244,0,217,0,237,0,137,0,219,0,116,0,0,0,52,0,0,0,232,0,0,0,2,0,0,0,173,0,168,0,0,0,247,0,0,0,129,0,67,0,220,0,162,0,105,0,230,0,172,0,249,0,157,0,76,0,190,0,25,0,206,0,14,0,200,0,0,0,232,0,76,0,160,0,9,0,200,0,48,0,43,0,0,0,159,0,66,0,70,0,251,0,0,0,153,0,26,0,0,0,42,0,0,0,154,0,0,0,0,0,95,0,23,0,0,0,168,0,162,0,0,0,187,0,233,0,0,0,0,0,31,0,162,0,167,0,0,0,63,0,192,0,224,0,66,0,94,0,129,0,109,0,213,0,0,0,101,0,0,0,219,0,117,0,139,0,42,0,77,0,168,0,214,0,0,0,210,0,173,0,129,0,0,0,244,0,58,0,179,0,0,0,62,0,70,0,37,0,166,0,247,0,4,0,197,0,66,0,151,0,225,0,125,0,255,0,201,0,0,0);
signal scenario_full  : scenario_type := (196,31,64,31,111,31,148,31,61,31,76,31,190,31,39,31,135,31,249,31,127,31,32,31,100,31,66,31,70,31,233,31,224,31,96,31,51,31,63,31,110,31,14,31,14,30,146,31,212,31,212,30,194,31,194,30,164,31,188,31,41,31,137,31,137,30,234,31,234,30,48,31,217,31,168,31,213,31,103,31,42,31,42,30,253,31,68,31,247,31,6,31,224,31,241,31,126,31,126,30,39,31,113,31,206,31,98,31,98,30,211,31,171,31,126,31,223,31,223,30,223,29,53,31,206,31,117,31,117,30,161,31,33,31,33,30,178,31,50,31,219,31,219,30,219,31,60,31,129,31,146,31,146,30,107,31,135,31,170,31,185,31,205,31,43,31,43,30,12,31,57,31,57,30,57,29,161,31,161,30,161,29,71,31,71,30,75,31,188,31,188,30,16,31,32,31,243,31,99,31,113,31,35,31,51,31,63,31,98,31,64,31,120,31,7,31,98,31,61,31,183,31,230,31,83,31,83,30,83,29,156,31,156,30,182,31,166,31,170,31,66,31,72,31,248,31,248,30,56,31,56,30,253,31,166,31,195,31,193,31,248,31,196,31,26,31,73,31,114,31,107,31,205,31,20,31,59,31,210,31,210,31,210,30,195,31,103,31,235,31,71,31,152,31,31,31,194,31,120,31,243,31,101,31,92,31,18,31,18,30,244,31,142,31,87,31,26,31,72,31,72,30,220,31,122,31,122,30,117,31,117,30,211,31,80,31,191,31,7,31,182,31,182,30,189,31,14,31,105,31,183,31,67,31,168,31,44,31,44,30,15,31,182,31,33,31,33,30,166,31,166,30,197,31,4,31,201,31,207,31,48,31,75,31,190,31,192,31,76,31,161,31,105,31,184,31,184,30,37,31,57,31,57,30,18,31,18,30,233,31,32,31,32,30,234,31,175,31,175,30,50,31,50,30,31,31,56,31,232,31,132,31,132,30,24,31,176,31,176,30,84,31,73,31,29,31,4,31,4,30,143,31,143,30,254,31,81,31,70,31,216,31,31,31,231,31,180,31,180,30,167,31,167,30,237,31,159,31,81,31,111,31,23,31,249,31,122,31,201,31,230,31,51,31,234,31,234,30,143,31,169,31,169,30,255,31,168,31,69,31,69,30,147,31,156,31,188,31,188,30,183,31,183,30,183,29,109,31,40,31,47,31,47,30,191,31,66,31,254,31,251,31,160,31,6,31,14,31,187,31,46,31,10,31,26,31,234,31,206,31,62,31,168,31,238,31,238,30,238,29,9,31,234,31,119,31,200,31,110,31,187,31,187,30,187,29,187,28,48,31,126,31,218,31,251,31,203,31,94,31,181,31,28,31,28,30,114,31,138,31,74,31,48,31,194,31,194,30,236,31,236,30,176,31,176,30,14,31,244,31,217,31,237,31,137,31,219,31,116,31,116,30,52,31,52,30,232,31,232,30,2,31,2,30,173,31,168,31,168,30,247,31,247,30,129,31,67,31,220,31,162,31,105,31,230,31,172,31,249,31,157,31,76,31,190,31,25,31,206,31,14,31,200,31,200,30,232,31,76,31,160,31,9,31,200,31,48,31,43,31,43,30,159,31,66,31,70,31,251,31,251,30,153,31,26,31,26,30,42,31,42,30,154,31,154,30,154,29,95,31,23,31,23,30,168,31,162,31,162,30,187,31,233,31,233,30,233,29,31,31,162,31,167,31,167,30,63,31,192,31,224,31,66,31,94,31,129,31,109,31,213,31,213,30,101,31,101,30,219,31,117,31,139,31,42,31,77,31,168,31,214,31,214,30,210,31,173,31,129,31,129,30,244,31,58,31,179,31,179,30,62,31,70,31,37,31,166,31,247,31,4,31,197,31,66,31,151,31,225,31,125,31,255,31,201,31,201,30);

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
