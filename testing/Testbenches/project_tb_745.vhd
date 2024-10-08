-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_745 is
end project_tb_745;

architecture project_tb_arch_745 of project_tb_745 is
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

constant SCENARIO_LENGTH : integer := 549;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,208,0,26,0,227,0,83,0,0,0,161,0,99,0,110,0,16,0,0,0,98,0,113,0,75,0,0,0,218,0,31,0,43,0,32,0,149,0,134,0,186,0,204,0,36,0,109,0,62,0,162,0,161,0,204,0,107,0,0,0,74,0,72,0,0,0,17,0,100,0,42,0,0,0,60,0,6,0,100,0,77,0,155,0,2,0,223,0,186,0,152,0,64,0,104,0,69,0,0,0,203,0,243,0,204,0,22,0,66,0,39,0,54,0,196,0,0,0,168,0,9,0,116,0,243,0,0,0,103,0,193,0,255,0,0,0,85,0,186,0,203,0,182,0,77,0,173,0,182,0,114,0,70,0,0,0,253,0,60,0,8,0,117,0,0,0,0,0,41,0,32,0,147,0,175,0,203,0,54,0,205,0,120,0,252,0,245,0,164,0,197,0,74,0,251,0,234,0,187,0,0,0,27,0,104,0,21,0,229,0,244,0,193,0,60,0,0,0,55,0,0,0,155,0,78,0,0,0,0,0,29,0,0,0,82,0,23,0,149,0,178,0,120,0,210,0,99,0,137,0,81,0,203,0,7,0,61,0,152,0,76,0,141,0,112,0,106,0,143,0,187,0,26,0,13,0,200,0,0,0,23,0,35,0,0,0,0,0,120,0,254,0,1,0,129,0,51,0,12,0,172,0,0,0,189,0,17,0,105,0,230,0,0,0,23,0,58,0,61,0,87,0,0,0,121,0,204,0,154,0,61,0,146,0,23,0,0,0,0,0,72,0,0,0,203,0,0,0,129,0,104,0,21,0,0,0,7,0,152,0,80,0,0,0,5,0,215,0,154,0,66,0,0,0,0,0,51,0,27,0,73,0,218,0,51,0,0,0,17,0,170,0,32,0,102,0,248,0,96,0,0,0,0,0,0,0,9,0,0,0,39,0,0,0,228,0,0,0,233,0,184,0,32,0,247,0,103,0,71,0,60,0,208,0,0,0,137,0,92,0,113,0,201,0,0,0,85,0,222,0,153,0,169,0,159,0,202,0,0,0,126,0,0,0,0,0,61,0,89,0,0,0,14,0,74,0,246,0,237,0,192,0,62,0,0,0,196,0,95,0,13,0,110,0,0,0,134,0,143,0,0,0,76,0,7,0,183,0,0,0,167,0,172,0,0,0,88,0,0,0,19,0,143,0,148,0,203,0,52,0,193,0,251,0,150,0,195,0,174,0,229,0,89,0,23,0,222,0,0,0,0,0,222,0,94,0,0,0,202,0,225,0,92,0,0,0,0,0,243,0,175,0,106,0,86,0,124,0,203,0,250,0,0,0,0,0,138,0,250,0,87,0,120,0,0,0,0,0,44,0,0,0,0,0,106,0,0,0,145,0,198,0,0,0,232,0,0,0,66,0,229,0,96,0,133,0,0,0,50,0,139,0,77,0,208,0,0,0,249,0,42,0,181,0,224,0,40,0,31,0,5,0,163,0,39,0,0,0,133,0,78,0,0,0,168,0,0,0,169,0,41,0,0,0,168,0,80,0,242,0,99,0,173,0,75,0,55,0,0,0,4,0,199,0,141,0,78,0,136,0,124,0,93,0,102,0,97,0,181,0,5,0,180,0,120,0,248,0,113,0,126,0,0,0,80,0,95,0,116,0,241,0,51,0,71,0,180,0,249,0,166,0,237,0,0,0,95,0,245,0,143,0,8,0,0,0,58,0,241,0,84,0,115,0,59,0,83,0,19,0,183,0,246,0,211,0,239,0,28,0,209,0,160,0,44,0,236,0,40,0,235,0,210,0,32,0,223,0,175,0,0,0,24,0,144,0,89,0,0,0,161,0,87,0,69,0,0,0,7,0,183,0,78,0,52,0,158,0,211,0,168,0,235,0,2,0,30,0,143,0,144,0,0,0,0,0,141,0,213,0,0,0,162,0,245,0,111,0,0,0,30,0,205,0,58,0,100,0,43,0,99,0,45,0,229,0,210,0,244,0,254,0,0,0,117,0,28,0,0,0,139,0,149,0,243,0,136,0,141,0,53,0,125,0,183,0,5,0,218,0,126,0,101,0,0,0,87,0,2,0,6,0,164,0,121,0,119,0,56,0,194,0,165,0,43,0,133,0,121,0,248,0,4,0,198,0,23,0,150,0,130,0,222,0,208,0,64,0,23,0,195,0,0,0,84,0,235,0,42,0,149,0,243,0,248,0,38,0,1,0,15,0,238,0,0,0,66,0,99,0,216,0,89,0,151,0,2,0,25,0,0,0,0,0,69,0,43,0,0,0,194,0,210,0,0,0,242,0,4,0,10,0,0,0,0,0,147,0,175,0,41,0,34,0,203,0,112,0,3,0,155,0,235,0,110,0,0,0,0,0,181,0,91,0,210,0,117,0,148,0,248,0,70,0,141,0,48,0,76,0,0,0,86,0,137,0,135,0,0,0,222,0,44,0,116,0,64,0,206,0,0,0,149,0,108,0);
signal scenario_full  : scenario_type := (0,0,208,31,26,31,227,31,83,31,83,30,161,31,99,31,110,31,16,31,16,30,98,31,113,31,75,31,75,30,218,31,31,31,43,31,32,31,149,31,134,31,186,31,204,31,36,31,109,31,62,31,162,31,161,31,204,31,107,31,107,30,74,31,72,31,72,30,17,31,100,31,42,31,42,30,60,31,6,31,100,31,77,31,155,31,2,31,223,31,186,31,152,31,64,31,104,31,69,31,69,30,203,31,243,31,204,31,22,31,66,31,39,31,54,31,196,31,196,30,168,31,9,31,116,31,243,31,243,30,103,31,193,31,255,31,255,30,85,31,186,31,203,31,182,31,77,31,173,31,182,31,114,31,70,31,70,30,253,31,60,31,8,31,117,31,117,30,117,29,41,31,32,31,147,31,175,31,203,31,54,31,205,31,120,31,252,31,245,31,164,31,197,31,74,31,251,31,234,31,187,31,187,30,27,31,104,31,21,31,229,31,244,31,193,31,60,31,60,30,55,31,55,30,155,31,78,31,78,30,78,29,29,31,29,30,82,31,23,31,149,31,178,31,120,31,210,31,99,31,137,31,81,31,203,31,7,31,61,31,152,31,76,31,141,31,112,31,106,31,143,31,187,31,26,31,13,31,200,31,200,30,23,31,35,31,35,30,35,29,120,31,254,31,1,31,129,31,51,31,12,31,172,31,172,30,189,31,17,31,105,31,230,31,230,30,23,31,58,31,61,31,87,31,87,30,121,31,204,31,154,31,61,31,146,31,23,31,23,30,23,29,72,31,72,30,203,31,203,30,129,31,104,31,21,31,21,30,7,31,152,31,80,31,80,30,5,31,215,31,154,31,66,31,66,30,66,29,51,31,27,31,73,31,218,31,51,31,51,30,17,31,170,31,32,31,102,31,248,31,96,31,96,30,96,29,96,28,9,31,9,30,39,31,39,30,228,31,228,30,233,31,184,31,32,31,247,31,103,31,71,31,60,31,208,31,208,30,137,31,92,31,113,31,201,31,201,30,85,31,222,31,153,31,169,31,159,31,202,31,202,30,126,31,126,30,126,29,61,31,89,31,89,30,14,31,74,31,246,31,237,31,192,31,62,31,62,30,196,31,95,31,13,31,110,31,110,30,134,31,143,31,143,30,76,31,7,31,183,31,183,30,167,31,172,31,172,30,88,31,88,30,19,31,143,31,148,31,203,31,52,31,193,31,251,31,150,31,195,31,174,31,229,31,89,31,23,31,222,31,222,30,222,29,222,31,94,31,94,30,202,31,225,31,92,31,92,30,92,29,243,31,175,31,106,31,86,31,124,31,203,31,250,31,250,30,250,29,138,31,250,31,87,31,120,31,120,30,120,29,44,31,44,30,44,29,106,31,106,30,145,31,198,31,198,30,232,31,232,30,66,31,229,31,96,31,133,31,133,30,50,31,139,31,77,31,208,31,208,30,249,31,42,31,181,31,224,31,40,31,31,31,5,31,163,31,39,31,39,30,133,31,78,31,78,30,168,31,168,30,169,31,41,31,41,30,168,31,80,31,242,31,99,31,173,31,75,31,55,31,55,30,4,31,199,31,141,31,78,31,136,31,124,31,93,31,102,31,97,31,181,31,5,31,180,31,120,31,248,31,113,31,126,31,126,30,80,31,95,31,116,31,241,31,51,31,71,31,180,31,249,31,166,31,237,31,237,30,95,31,245,31,143,31,8,31,8,30,58,31,241,31,84,31,115,31,59,31,83,31,19,31,183,31,246,31,211,31,239,31,28,31,209,31,160,31,44,31,236,31,40,31,235,31,210,31,32,31,223,31,175,31,175,30,24,31,144,31,89,31,89,30,161,31,87,31,69,31,69,30,7,31,183,31,78,31,52,31,158,31,211,31,168,31,235,31,2,31,30,31,143,31,144,31,144,30,144,29,141,31,213,31,213,30,162,31,245,31,111,31,111,30,30,31,205,31,58,31,100,31,43,31,99,31,45,31,229,31,210,31,244,31,254,31,254,30,117,31,28,31,28,30,139,31,149,31,243,31,136,31,141,31,53,31,125,31,183,31,5,31,218,31,126,31,101,31,101,30,87,31,2,31,6,31,164,31,121,31,119,31,56,31,194,31,165,31,43,31,133,31,121,31,248,31,4,31,198,31,23,31,150,31,130,31,222,31,208,31,64,31,23,31,195,31,195,30,84,31,235,31,42,31,149,31,243,31,248,31,38,31,1,31,15,31,238,31,238,30,66,31,99,31,216,31,89,31,151,31,2,31,25,31,25,30,25,29,69,31,43,31,43,30,194,31,210,31,210,30,242,31,4,31,10,31,10,30,10,29,147,31,175,31,41,31,34,31,203,31,112,31,3,31,155,31,235,31,110,31,110,30,110,29,181,31,91,31,210,31,117,31,148,31,248,31,70,31,141,31,48,31,76,31,76,30,86,31,137,31,135,31,135,30,222,31,44,31,116,31,64,31,206,31,206,30,149,31,108,31);

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
