-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_841 is
end project_tb_841;

architecture project_tb_arch_841 of project_tb_841 is
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

constant SCENARIO_LENGTH : integer := 563;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (146,0,197,0,181,0,250,0,0,0,252,0,0,0,0,0,109,0,57,0,192,0,120,0,33,0,135,0,74,0,71,0,6,0,164,0,131,0,4,0,252,0,53,0,0,0,198,0,229,0,86,0,11,0,228,0,189,0,176,0,0,0,209,0,7,0,0,0,90,0,210,0,229,0,182,0,255,0,176,0,75,0,5,0,198,0,0,0,214,0,26,0,89,0,0,0,118,0,16,0,226,0,130,0,161,0,0,0,141,0,5,0,242,0,68,0,162,0,129,0,173,0,0,0,136,0,9,0,0,0,41,0,165,0,0,0,135,0,211,0,145,0,121,0,162,0,34,0,225,0,0,0,232,0,21,0,107,0,119,0,0,0,155,0,0,0,94,0,96,0,132,0,152,0,119,0,117,0,75,0,117,0,110,0,0,0,119,0,140,0,0,0,25,0,187,0,170,0,144,0,121,0,198,0,234,0,164,0,189,0,0,0,88,0,135,0,0,0,40,0,237,0,164,0,253,0,231,0,211,0,0,0,162,0,207,0,27,0,168,0,81,0,227,0,166,0,0,0,176,0,88,0,123,0,0,0,194,0,0,0,0,0,73,0,0,0,167,0,8,0,171,0,213,0,180,0,143,0,185,0,72,0,89,0,69,0,151,0,0,0,14,0,0,0,35,0,0,0,52,0,198,0,0,0,226,0,92,0,182,0,0,0,0,0,30,0,18,0,0,0,149,0,0,0,0,0,84,0,161,0,232,0,250,0,238,0,0,0,0,0,50,0,0,0,145,0,0,0,14,0,59,0,28,0,164,0,16,0,75,0,235,0,67,0,90,0,189,0,176,0,220,0,195,0,86,0,0,0,67,0,209,0,103,0,220,0,0,0,185,0,0,0,13,0,115,0,166,0,180,0,28,0,82,0,189,0,252,0,95,0,0,0,14,0,127,0,13,0,28,0,0,0,232,0,136,0,239,0,211,0,0,0,211,0,226,0,214,0,155,0,133,0,86,0,0,0,21,0,175,0,75,0,0,0,171,0,0,0,0,0,72,0,31,0,228,0,21,0,173,0,153,0,56,0,227,0,117,0,52,0,155,0,0,0,22,0,150,0,142,0,41,0,0,0,29,0,155,0,195,0,23,0,213,0,0,0,227,0,132,0,248,0,43,0,66,0,166,0,185,0,0,0,212,0,49,0,136,0,123,0,160,0,150,0,71,0,88,0,111,0,235,0,39,0,216,0,25,0,0,0,118,0,207,0,23,0,246,0,238,0,219,0,0,0,46,0,56,0,0,0,0,0,255,0,28,0,108,0,67,0,56,0,136,0,85,0,160,0,0,0,181,0,191,0,250,0,210,0,163,0,98,0,139,0,145,0,218,0,62,0,203,0,175,0,222,0,222,0,69,0,229,0,0,0,239,0,220,0,59,0,143,0,153,0,37,0,106,0,132,0,0,0,0,0,82,0,163,0,227,0,0,0,0,0,161,0,117,0,119,0,23,0,123,0,110,0,45,0,246,0,190,0,57,0,52,0,0,0,27,0,83,0,130,0,252,0,183,0,211,0,225,0,62,0,0,0,142,0,57,0,65,0,113,0,196,0,0,0,235,0,69,0,75,0,1,0,149,0,61,0,94,0,129,0,74,0,172,0,49,0,185,0,0,0,103,0,12,0,248,0,94,0,111,0,42,0,175,0,171,0,16,0,54,0,16,0,197,0,239,0,158,0,120,0,234,0,0,0,30,0,37,0,76,0,43,0,48,0,0,0,71,0,245,0,33,0,61,0,0,0,234,0,232,0,86,0,88,0,213,0,0,0,230,0,74,0,81,0,160,0,133,0,255,0,0,0,74,0,191,0,233,0,214,0,1,0,27,0,29,0,165,0,79,0,19,0,218,0,0,0,146,0,93,0,248,0,222,0,220,0,0,0,76,0,166,0,0,0,104,0,91,0,0,0,125,0,230,0,0,0,209,0,43,0,0,0,0,0,245,0,197,0,96,0,26,0,225,0,27,0,0,0,217,0,44,0,64,0,10,0,93,0,133,0,168,0,91,0,193,0,8,0,4,0,108,0,0,0,176,0,33,0,104,0,0,0,62,0,0,0,0,0,196,0,102,0,111,0,31,0,137,0,178,0,56,0,107,0,119,0,74,0,134,0,0,0,212,0,120,0,234,0,151,0,0,0,10,0,49,0,3,0,158,0,186,0,10,0,6,0,6,0,24,0,227,0,58,0,53,0,75,0,186,0,161,0,133,0,0,0,0,0,70,0,108,0,35,0,240,0,208,0,0,0,94,0,28,0,0,0,147,0,178,0,83,0,253,0,175,0,129,0,203,0,81,0,18,0,12,0,87,0,231,0,0,0,0,0,90,0,171,0,109,0,167,0,15,0,29,0,0,0,183,0,156,0,57,0,0,0,79,0,219,0,29,0,43,0,195,0,239,0,64,0,0,0,211,0,235,0,214,0,225,0,0,0,68,0,3,0,0,0,30,0,60,0,0,0,242,0,0,0,53,0,188,0,111,0,0,0,0,0,236,0,24,0);
signal scenario_full  : scenario_type := (146,31,197,31,181,31,250,31,250,30,252,31,252,30,252,29,109,31,57,31,192,31,120,31,33,31,135,31,74,31,71,31,6,31,164,31,131,31,4,31,252,31,53,31,53,30,198,31,229,31,86,31,11,31,228,31,189,31,176,31,176,30,209,31,7,31,7,30,90,31,210,31,229,31,182,31,255,31,176,31,75,31,5,31,198,31,198,30,214,31,26,31,89,31,89,30,118,31,16,31,226,31,130,31,161,31,161,30,141,31,5,31,242,31,68,31,162,31,129,31,173,31,173,30,136,31,9,31,9,30,41,31,165,31,165,30,135,31,211,31,145,31,121,31,162,31,34,31,225,31,225,30,232,31,21,31,107,31,119,31,119,30,155,31,155,30,94,31,96,31,132,31,152,31,119,31,117,31,75,31,117,31,110,31,110,30,119,31,140,31,140,30,25,31,187,31,170,31,144,31,121,31,198,31,234,31,164,31,189,31,189,30,88,31,135,31,135,30,40,31,237,31,164,31,253,31,231,31,211,31,211,30,162,31,207,31,27,31,168,31,81,31,227,31,166,31,166,30,176,31,88,31,123,31,123,30,194,31,194,30,194,29,73,31,73,30,167,31,8,31,171,31,213,31,180,31,143,31,185,31,72,31,89,31,69,31,151,31,151,30,14,31,14,30,35,31,35,30,52,31,198,31,198,30,226,31,92,31,182,31,182,30,182,29,30,31,18,31,18,30,149,31,149,30,149,29,84,31,161,31,232,31,250,31,238,31,238,30,238,29,50,31,50,30,145,31,145,30,14,31,59,31,28,31,164,31,16,31,75,31,235,31,67,31,90,31,189,31,176,31,220,31,195,31,86,31,86,30,67,31,209,31,103,31,220,31,220,30,185,31,185,30,13,31,115,31,166,31,180,31,28,31,82,31,189,31,252,31,95,31,95,30,14,31,127,31,13,31,28,31,28,30,232,31,136,31,239,31,211,31,211,30,211,31,226,31,214,31,155,31,133,31,86,31,86,30,21,31,175,31,75,31,75,30,171,31,171,30,171,29,72,31,31,31,228,31,21,31,173,31,153,31,56,31,227,31,117,31,52,31,155,31,155,30,22,31,150,31,142,31,41,31,41,30,29,31,155,31,195,31,23,31,213,31,213,30,227,31,132,31,248,31,43,31,66,31,166,31,185,31,185,30,212,31,49,31,136,31,123,31,160,31,150,31,71,31,88,31,111,31,235,31,39,31,216,31,25,31,25,30,118,31,207,31,23,31,246,31,238,31,219,31,219,30,46,31,56,31,56,30,56,29,255,31,28,31,108,31,67,31,56,31,136,31,85,31,160,31,160,30,181,31,191,31,250,31,210,31,163,31,98,31,139,31,145,31,218,31,62,31,203,31,175,31,222,31,222,31,69,31,229,31,229,30,239,31,220,31,59,31,143,31,153,31,37,31,106,31,132,31,132,30,132,29,82,31,163,31,227,31,227,30,227,29,161,31,117,31,119,31,23,31,123,31,110,31,45,31,246,31,190,31,57,31,52,31,52,30,27,31,83,31,130,31,252,31,183,31,211,31,225,31,62,31,62,30,142,31,57,31,65,31,113,31,196,31,196,30,235,31,69,31,75,31,1,31,149,31,61,31,94,31,129,31,74,31,172,31,49,31,185,31,185,30,103,31,12,31,248,31,94,31,111,31,42,31,175,31,171,31,16,31,54,31,16,31,197,31,239,31,158,31,120,31,234,31,234,30,30,31,37,31,76,31,43,31,48,31,48,30,71,31,245,31,33,31,61,31,61,30,234,31,232,31,86,31,88,31,213,31,213,30,230,31,74,31,81,31,160,31,133,31,255,31,255,30,74,31,191,31,233,31,214,31,1,31,27,31,29,31,165,31,79,31,19,31,218,31,218,30,146,31,93,31,248,31,222,31,220,31,220,30,76,31,166,31,166,30,104,31,91,31,91,30,125,31,230,31,230,30,209,31,43,31,43,30,43,29,245,31,197,31,96,31,26,31,225,31,27,31,27,30,217,31,44,31,64,31,10,31,93,31,133,31,168,31,91,31,193,31,8,31,4,31,108,31,108,30,176,31,33,31,104,31,104,30,62,31,62,30,62,29,196,31,102,31,111,31,31,31,137,31,178,31,56,31,107,31,119,31,74,31,134,31,134,30,212,31,120,31,234,31,151,31,151,30,10,31,49,31,3,31,158,31,186,31,10,31,6,31,6,31,24,31,227,31,58,31,53,31,75,31,186,31,161,31,133,31,133,30,133,29,70,31,108,31,35,31,240,31,208,31,208,30,94,31,28,31,28,30,147,31,178,31,83,31,253,31,175,31,129,31,203,31,81,31,18,31,12,31,87,31,231,31,231,30,231,29,90,31,171,31,109,31,167,31,15,31,29,31,29,30,183,31,156,31,57,31,57,30,79,31,219,31,29,31,43,31,195,31,239,31,64,31,64,30,211,31,235,31,214,31,225,31,225,30,68,31,3,31,3,30,30,31,60,31,60,30,242,31,242,30,53,31,188,31,111,31,111,30,111,29,236,31,24,31);

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
