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

constant SCENARIO_LENGTH : integer := 431;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,124,0,159,0,145,0,200,0,106,0,0,0,0,0,0,0,135,0,0,0,62,0,124,0,87,0,8,0,0,0,0,0,40,0,6,0,12,0,27,0,0,0,204,0,252,0,143,0,182,0,189,0,65,0,149,0,55,0,201,0,252,0,0,0,96,0,217,0,58,0,243,0,140,0,60,0,108,0,0,0,0,0,0,0,91,0,230,0,92,0,198,0,0,0,191,0,172,0,0,0,228,0,0,0,66,0,149,0,202,0,175,0,33,0,70,0,0,0,237,0,104,0,202,0,235,0,0,0,204,0,186,0,219,0,160,0,241,0,0,0,162,0,203,0,0,0,192,0,105,0,16,0,160,0,24,0,129,0,113,0,193,0,24,0,0,0,0,0,0,0,0,0,24,0,0,0,168,0,187,0,249,0,105,0,100,0,0,0,170,0,3,0,0,0,223,0,0,0,103,0,60,0,0,0,0,0,144,0,190,0,0,0,149,0,110,0,229,0,57,0,0,0,134,0,221,0,87,0,189,0,55,0,195,0,0,0,241,0,151,0,95,0,113,0,123,0,203,0,133,0,0,0,187,0,32,0,176,0,0,0,196,0,44,0,143,0,74,0,28,0,94,0,78,0,149,0,233,0,74,0,1,0,0,0,169,0,172,0,187,0,254,0,0,0,31,0,206,0,161,0,136,0,0,0,50,0,93,0,155,0,122,0,0,0,77,0,54,0,203,0,16,0,0,0,139,0,232,0,206,0,0,0,75,0,0,0,196,0,25,0,40,0,54,0,215,0,95,0,14,0,129,0,135,0,137,0,115,0,27,0,0,0,0,0,28,0,0,0,105,0,0,0,83,0,130,0,212,0,104,0,0,0,102,0,42,0,69,0,0,0,68,0,246,0,160,0,0,0,134,0,56,0,181,0,40,0,74,0,0,0,30,0,163,0,28,0,254,0,240,0,232,0,0,0,0,0,153,0,0,0,116,0,133,0,88,0,148,0,57,0,28,0,0,0,23,0,151,0,253,0,79,0,43,0,0,0,155,0,0,0,87,0,0,0,0,0,23,0,104,0,0,0,255,0,91,0,30,0,127,0,170,0,4,0,142,0,0,0,77,0,197,0,197,0,203,0,231,0,178,0,0,0,34,0,130,0,178,0,14,0,240,0,74,0,78,0,196,0,0,0,0,0,9,0,32,0,159,0,66,0,0,0,47,0,0,0,35,0,7,0,18,0,62,0,11,0,124,0,95,0,0,0,7,0,28,0,128,0,178,0,208,0,127,0,0,0,0,0,0,0,166,0,81,0,0,0,0,0,0,0,47,0,0,0,227,0,53,0,112,0,227,0,0,0,43,0,243,0,0,0,179,0,187,0,69,0,0,0,172,0,0,0,104,0,40,0,154,0,47,0,152,0,200,0,246,0,206,0,112,0,202,0,230,0,145,0,16,0,154,0,118,0,14,0,0,0,143,0,178,0,0,0,215,0,0,0,11,0,126,0,135,0,223,0,159,0,0,0,123,0,15,0,0,0,80,0,134,0,51,0,184,0,117,0,12,0,0,0,105,0,0,0,29,0,130,0,139,0,184,0,0,0,186,0,212,0,21,0,134,0,10,0,169,0,211,0,138,0,0,0,152,0,28,0,60,0,81,0,241,0,0,0,0,0,0,0,0,0,85,0,88,0,125,0,69,0,137,0,0,0,208,0,148,0,14,0,153,0,125,0,169,0,0,0,228,0,174,0,252,0,61,0,92,0,150,0,255,0,62,0,234,0,169,0,0,0,41,0,210,0,7,0,78,0,0,0,201,0,190,0,179,0,192,0,235,0,0,0,179,0,229,0,0,0,0,0,255,0,67,0,138,0,0,0,148,0,255,0,17,0,203,0,0,0,0,0,50,0,102,0,0,0,170,0,145,0,218,0,177,0,199,0,89,0,0,0,0,0,139,0);
signal scenario_full  : scenario_type := (0,0,124,31,159,31,145,31,200,31,106,31,106,30,106,29,106,28,135,31,135,30,62,31,124,31,87,31,8,31,8,30,8,29,40,31,6,31,12,31,27,31,27,30,204,31,252,31,143,31,182,31,189,31,65,31,149,31,55,31,201,31,252,31,252,30,96,31,217,31,58,31,243,31,140,31,60,31,108,31,108,30,108,29,108,28,91,31,230,31,92,31,198,31,198,30,191,31,172,31,172,30,228,31,228,30,66,31,149,31,202,31,175,31,33,31,70,31,70,30,237,31,104,31,202,31,235,31,235,30,204,31,186,31,219,31,160,31,241,31,241,30,162,31,203,31,203,30,192,31,105,31,16,31,160,31,24,31,129,31,113,31,193,31,24,31,24,30,24,29,24,28,24,27,24,31,24,30,168,31,187,31,249,31,105,31,100,31,100,30,170,31,3,31,3,30,223,31,223,30,103,31,60,31,60,30,60,29,144,31,190,31,190,30,149,31,110,31,229,31,57,31,57,30,134,31,221,31,87,31,189,31,55,31,195,31,195,30,241,31,151,31,95,31,113,31,123,31,203,31,133,31,133,30,187,31,32,31,176,31,176,30,196,31,44,31,143,31,74,31,28,31,94,31,78,31,149,31,233,31,74,31,1,31,1,30,169,31,172,31,187,31,254,31,254,30,31,31,206,31,161,31,136,31,136,30,50,31,93,31,155,31,122,31,122,30,77,31,54,31,203,31,16,31,16,30,139,31,232,31,206,31,206,30,75,31,75,30,196,31,25,31,40,31,54,31,215,31,95,31,14,31,129,31,135,31,137,31,115,31,27,31,27,30,27,29,28,31,28,30,105,31,105,30,83,31,130,31,212,31,104,31,104,30,102,31,42,31,69,31,69,30,68,31,246,31,160,31,160,30,134,31,56,31,181,31,40,31,74,31,74,30,30,31,163,31,28,31,254,31,240,31,232,31,232,30,232,29,153,31,153,30,116,31,133,31,88,31,148,31,57,31,28,31,28,30,23,31,151,31,253,31,79,31,43,31,43,30,155,31,155,30,87,31,87,30,87,29,23,31,104,31,104,30,255,31,91,31,30,31,127,31,170,31,4,31,142,31,142,30,77,31,197,31,197,31,203,31,231,31,178,31,178,30,34,31,130,31,178,31,14,31,240,31,74,31,78,31,196,31,196,30,196,29,9,31,32,31,159,31,66,31,66,30,47,31,47,30,35,31,7,31,18,31,62,31,11,31,124,31,95,31,95,30,7,31,28,31,128,31,178,31,208,31,127,31,127,30,127,29,127,28,166,31,81,31,81,30,81,29,81,28,47,31,47,30,227,31,53,31,112,31,227,31,227,30,43,31,243,31,243,30,179,31,187,31,69,31,69,30,172,31,172,30,104,31,40,31,154,31,47,31,152,31,200,31,246,31,206,31,112,31,202,31,230,31,145,31,16,31,154,31,118,31,14,31,14,30,143,31,178,31,178,30,215,31,215,30,11,31,126,31,135,31,223,31,159,31,159,30,123,31,15,31,15,30,80,31,134,31,51,31,184,31,117,31,12,31,12,30,105,31,105,30,29,31,130,31,139,31,184,31,184,30,186,31,212,31,21,31,134,31,10,31,169,31,211,31,138,31,138,30,152,31,28,31,60,31,81,31,241,31,241,30,241,29,241,28,241,27,85,31,88,31,125,31,69,31,137,31,137,30,208,31,148,31,14,31,153,31,125,31,169,31,169,30,228,31,174,31,252,31,61,31,92,31,150,31,255,31,62,31,234,31,169,31,169,30,41,31,210,31,7,31,78,31,78,30,201,31,190,31,179,31,192,31,235,31,235,30,179,31,229,31,229,30,229,29,255,31,67,31,138,31,138,30,148,31,255,31,17,31,203,31,203,30,203,29,50,31,102,31,102,30,170,31,145,31,218,31,177,31,199,31,89,31,89,30,89,29,139,31);

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
