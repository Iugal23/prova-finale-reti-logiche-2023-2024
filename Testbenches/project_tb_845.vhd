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

constant SCENARIO_LENGTH : integer := 572;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (231,0,0,0,48,0,253,0,0,0,139,0,155,0,238,0,11,0,169,0,0,0,92,0,78,0,252,0,0,0,141,0,0,0,31,0,102,0,116,0,67,0,197,0,237,0,253,0,0,0,204,0,41,0,222,0,214,0,0,0,0,0,140,0,177,0,0,0,235,0,158,0,193,0,82,0,67,0,93,0,248,0,157,0,232,0,217,0,13,0,127,0,79,0,52,0,0,0,8,0,0,0,201,0,138,0,149,0,235,0,0,0,181,0,0,0,228,0,115,0,221,0,248,0,92,0,31,0,191,0,251,0,56,0,115,0,140,0,0,0,75,0,0,0,100,0,232,0,68,0,23,0,130,0,149,0,0,0,101,0,0,0,246,0,237,0,52,0,158,0,0,0,169,0,0,0,68,0,72,0,88,0,0,0,0,0,61,0,219,0,180,0,255,0,91,0,164,0,187,0,136,0,119,0,152,0,43,0,122,0,0,0,45,0,234,0,178,0,9,0,0,0,49,0,0,0,126,0,163,0,78,0,17,0,118,0,209,0,240,0,0,0,108,0,88,0,207,0,0,0,31,0,90,0,0,0,108,0,191,0,228,0,184,0,53,0,118,0,184,0,188,0,157,0,43,0,137,0,69,0,248,0,206,0,150,0,126,0,230,0,247,0,0,0,117,0,170,0,0,0,112,0,46,0,0,0,237,0,192,0,0,0,245,0,210,0,115,0,48,0,70,0,137,0,159,0,111,0,233,0,0,0,76,0,209,0,219,0,0,0,220,0,0,0,92,0,109,0,30,0,60,0,62,0,0,0,220,0,160,0,3,0,79,0,92,0,0,0,143,0,0,0,238,0,121,0,0,0,147,0,158,0,150,0,0,0,0,0,29,0,245,0,16,0,97,0,118,0,9,0,36,0,248,0,23,0,251,0,24,0,186,0,62,0,229,0,10,0,0,0,194,0,127,0,121,0,32,0,0,0,78,0,84,0,231,0,251,0,0,0,212,0,243,0,52,0,252,0,229,0,152,0,219,0,67,0,94,0,156,0,0,0,0,0,84,0,36,0,79,0,114,0,90,0,133,0,79,0,227,0,171,0,146,0,129,0,120,0,16,0,0,0,117,0,0,0,0,0,112,0,136,0,32,0,3,0,17,0,240,0,212,0,254,0,182,0,241,0,121,0,0,0,149,0,0,0,0,0,0,0,143,0,217,0,22,0,0,0,80,0,202,0,0,0,0,0,188,0,192,0,194,0,65,0,73,0,3,0,140,0,68,0,87,0,155,0,18,0,232,0,0,0,225,0,230,0,30,0,9,0,0,0,255,0,73,0,168,0,120,0,55,0,75,0,62,0,116,0,239,0,0,0,148,0,115,0,30,0,186,0,141,0,112,0,181,0,215,0,115,0,137,0,112,0,166,0,136,0,49,0,51,0,78,0,0,0,181,0,190,0,126,0,106,0,137,0,102,0,0,0,85,0,34,0,0,0,88,0,228,0,133,0,0,0,240,0,127,0,31,0,196,0,244,0,144,0,0,0,0,0,189,0,0,0,200,0,149,0,0,0,106,0,150,0,21,0,5,0,96,0,171,0,119,0,21,0,162,0,118,0,206,0,30,0,100,0,191,0,52,0,248,0,92,0,0,0,126,0,208,0,147,0,118,0,132,0,56,0,166,0,164,0,135,0,0,0,165,0,157,0,96,0,26,0,233,0,81,0,244,0,234,0,73,0,11,0,106,0,0,0,241,0,139,0,0,0,0,0,9,0,0,0,25,0,185,0,0,0,0,0,186,0,0,0,220,0,0,0,167,0,164,0,36,0,218,0,205,0,74,0,139,0,90,0,190,0,0,0,103,0,122,0,158,0,26,0,59,0,54,0,200,0,78,0,105,0,0,0,199,0,39,0,0,0,126,0,114,0,252,0,215,0,220,0,55,0,65,0,141,0,174,0,113,0,56,0,35,0,234,0,5,0,83,0,65,0,229,0,145,0,159,0,154,0,199,0,0,0,236,0,33,0,167,0,228,0,122,0,80,0,83,0,189,0,208,0,17,0,71,0,4,0,116,0,0,0,0,0,0,0,0,0,0,0,111,0,51,0,82,0,0,0,0,0,251,0,233,0,149,0,139,0,138,0,0,0,48,0,134,0,0,0,0,0,0,0,0,0,71,0,170,0,97,0,0,0,89,0,193,0,0,0,193,0,182,0,103,0,39,0,0,0,120,0,166,0,198,0,76,0,0,0,128,0,0,0,206,0,0,0,6,0,40,0,0,0,19,0,50,0,53,0,161,0,150,0,99,0,19,0,60,0,195,0,192,0,155,0,86,0,102,0,137,0,231,0,160,0,0,0,201,0,17,0,58,0,49,0,190,0,13,0,0,0,19,0,179,0,51,0,0,0,196,0,190,0,0,0,172,0,99,0,49,0,170,0,65,0,206,0,0,0,116,0,246,0,240,0,248,0,0,0,224,0,7,0,95,0,140,0,0,0,239,0,0,0,0,0,0,0,207,0,198,0,0,0,10,0,96,0,0,0,150,0,121,0,0,0,0,0,0,0,31,0,0,0,212,0,171,0,253,0,45,0);
signal scenario_full  : scenario_type := (231,31,231,30,48,31,253,31,253,30,139,31,155,31,238,31,11,31,169,31,169,30,92,31,78,31,252,31,252,30,141,31,141,30,31,31,102,31,116,31,67,31,197,31,237,31,253,31,253,30,204,31,41,31,222,31,214,31,214,30,214,29,140,31,177,31,177,30,235,31,158,31,193,31,82,31,67,31,93,31,248,31,157,31,232,31,217,31,13,31,127,31,79,31,52,31,52,30,8,31,8,30,201,31,138,31,149,31,235,31,235,30,181,31,181,30,228,31,115,31,221,31,248,31,92,31,31,31,191,31,251,31,56,31,115,31,140,31,140,30,75,31,75,30,100,31,232,31,68,31,23,31,130,31,149,31,149,30,101,31,101,30,246,31,237,31,52,31,158,31,158,30,169,31,169,30,68,31,72,31,88,31,88,30,88,29,61,31,219,31,180,31,255,31,91,31,164,31,187,31,136,31,119,31,152,31,43,31,122,31,122,30,45,31,234,31,178,31,9,31,9,30,49,31,49,30,126,31,163,31,78,31,17,31,118,31,209,31,240,31,240,30,108,31,88,31,207,31,207,30,31,31,90,31,90,30,108,31,191,31,228,31,184,31,53,31,118,31,184,31,188,31,157,31,43,31,137,31,69,31,248,31,206,31,150,31,126,31,230,31,247,31,247,30,117,31,170,31,170,30,112,31,46,31,46,30,237,31,192,31,192,30,245,31,210,31,115,31,48,31,70,31,137,31,159,31,111,31,233,31,233,30,76,31,209,31,219,31,219,30,220,31,220,30,92,31,109,31,30,31,60,31,62,31,62,30,220,31,160,31,3,31,79,31,92,31,92,30,143,31,143,30,238,31,121,31,121,30,147,31,158,31,150,31,150,30,150,29,29,31,245,31,16,31,97,31,118,31,9,31,36,31,248,31,23,31,251,31,24,31,186,31,62,31,229,31,10,31,10,30,194,31,127,31,121,31,32,31,32,30,78,31,84,31,231,31,251,31,251,30,212,31,243,31,52,31,252,31,229,31,152,31,219,31,67,31,94,31,156,31,156,30,156,29,84,31,36,31,79,31,114,31,90,31,133,31,79,31,227,31,171,31,146,31,129,31,120,31,16,31,16,30,117,31,117,30,117,29,112,31,136,31,32,31,3,31,17,31,240,31,212,31,254,31,182,31,241,31,121,31,121,30,149,31,149,30,149,29,149,28,143,31,217,31,22,31,22,30,80,31,202,31,202,30,202,29,188,31,192,31,194,31,65,31,73,31,3,31,140,31,68,31,87,31,155,31,18,31,232,31,232,30,225,31,230,31,30,31,9,31,9,30,255,31,73,31,168,31,120,31,55,31,75,31,62,31,116,31,239,31,239,30,148,31,115,31,30,31,186,31,141,31,112,31,181,31,215,31,115,31,137,31,112,31,166,31,136,31,49,31,51,31,78,31,78,30,181,31,190,31,126,31,106,31,137,31,102,31,102,30,85,31,34,31,34,30,88,31,228,31,133,31,133,30,240,31,127,31,31,31,196,31,244,31,144,31,144,30,144,29,189,31,189,30,200,31,149,31,149,30,106,31,150,31,21,31,5,31,96,31,171,31,119,31,21,31,162,31,118,31,206,31,30,31,100,31,191,31,52,31,248,31,92,31,92,30,126,31,208,31,147,31,118,31,132,31,56,31,166,31,164,31,135,31,135,30,165,31,157,31,96,31,26,31,233,31,81,31,244,31,234,31,73,31,11,31,106,31,106,30,241,31,139,31,139,30,139,29,9,31,9,30,25,31,185,31,185,30,185,29,186,31,186,30,220,31,220,30,167,31,164,31,36,31,218,31,205,31,74,31,139,31,90,31,190,31,190,30,103,31,122,31,158,31,26,31,59,31,54,31,200,31,78,31,105,31,105,30,199,31,39,31,39,30,126,31,114,31,252,31,215,31,220,31,55,31,65,31,141,31,174,31,113,31,56,31,35,31,234,31,5,31,83,31,65,31,229,31,145,31,159,31,154,31,199,31,199,30,236,31,33,31,167,31,228,31,122,31,80,31,83,31,189,31,208,31,17,31,71,31,4,31,116,31,116,30,116,29,116,28,116,27,116,26,111,31,51,31,82,31,82,30,82,29,251,31,233,31,149,31,139,31,138,31,138,30,48,31,134,31,134,30,134,29,134,28,134,27,71,31,170,31,97,31,97,30,89,31,193,31,193,30,193,31,182,31,103,31,39,31,39,30,120,31,166,31,198,31,76,31,76,30,128,31,128,30,206,31,206,30,6,31,40,31,40,30,19,31,50,31,53,31,161,31,150,31,99,31,19,31,60,31,195,31,192,31,155,31,86,31,102,31,137,31,231,31,160,31,160,30,201,31,17,31,58,31,49,31,190,31,13,31,13,30,19,31,179,31,51,31,51,30,196,31,190,31,190,30,172,31,99,31,49,31,170,31,65,31,206,31,206,30,116,31,246,31,240,31,248,31,248,30,224,31,7,31,95,31,140,31,140,30,239,31,239,30,239,29,239,28,207,31,198,31,198,30,10,31,96,31,96,30,150,31,121,31,121,30,121,29,121,28,31,31,31,30,212,31,171,31,253,31,45,31);

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
